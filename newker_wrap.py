#!/usr/bin/env python3
"""
newker_wrap.py

Small “wrapper” utility for producing Newker-friendly NC files from generic ISO/Fanuc-like G-code.

It can:
- strip existing % / O#### / :#### header/footer
- add a configurable header and footer (safe start / safe end)
- optionally remove existing N-line numbers and re-number blocks
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Optional, Sequence


_RE_EMPTY = re.compile(r"^\s*$")
_RE_PERCENT = re.compile(r"^\s*%\s*$")
_RE_O_PROG = re.compile(r"^\s*O(?P<num>\d+)\s*(?:\([^)]*\)\s*)?$", re.IGNORECASE)
_RE_COLON_PROG = re.compile(r"^\s*:(?P<num>\d+)\s*(?:\([^)]*\)\s*)?$")
_RE_N_PREFIX = re.compile(r"^\s*N\d+\s*", re.IGNORECASE)


@dataclass(frozen=True)
class WrapOptions:
    program: str
    program_style: str  # 'O' or ':'
    units: str  # 'mm' or 'inch'
    wcs: Optional[str]  # e.g. 'G54'
    include_percent: bool
    include_comment: Optional[str]
    safe_start: bool
    safe_end: bool
    home_end: bool
    strip_existing_header_footer: bool
    strip_n_numbers: bool
    renumber: bool
    renumber_start: int
    renumber_step: int


def _read_text(path: Path) -> str:
    # Be forgiving: many controllers accept ASCII-ish; replace invalid bytes.
    return path.read_text(encoding="utf-8", errors="replace")


def _normalize_lines(text: str) -> List[str]:
    # Normalize newlines, keep line order.
    return text.replace("\r\n", "\n").replace("\r", "\n").split("\n")


def _strip_outer_percent(lines: List[str]) -> List[str]:
    while lines and _RE_EMPTY.match(lines[0]):
        lines.pop(0)
    while lines and _RE_EMPTY.match(lines[-1]):
        lines.pop()
    if lines and _RE_PERCENT.match(lines[0]):
        lines.pop(0)
        while lines and _RE_EMPTY.match(lines[0]):
            lines.pop(0)
    if lines and _RE_PERCENT.match(lines[-1]):
        lines.pop()
        while lines and _RE_EMPTY.match(lines[-1]):
            lines.pop()
    return lines


def _strip_outer_program_number(lines: List[str]) -> List[str]:
    # Remove one program number line at the top if present.
    while lines and _RE_EMPTY.match(lines[0]):
        lines.pop(0)
    if lines and (_RE_O_PROG.match(lines[0]) or _RE_COLON_PROG.match(lines[0])):
        lines.pop(0)
        while lines and _RE_EMPTY.match(lines[0]):
            lines.pop(0)
    return lines


def _strip_trailing_m30_m2(lines: List[str]) -> List[str]:
    # Remove trailing end-program codes if present (common in ISO/Fanuc style).
    while lines and _RE_EMPTY.match(lines[-1]):
        lines.pop()
    if not lines:
        return lines

    # Accept "M30", "M2", optionally preceded by N-number and spaces; allow comments after.
    end_re = re.compile(r"^\s*(?:N\d+\s*)?(M30|M2)\b.*$", re.IGNORECASE)
    if end_re.match(lines[-1]):
        lines.pop()
        while lines and _RE_EMPTY.match(lines[-1]):
            lines.pop()
    return lines


def _strip_n_numbers(lines: Iterable[str]) -> List[str]:
    return [_RE_N_PREFIX.sub("", ln) for ln in lines]


def _renumber(lines: Iterable[str], start: int, step: int) -> List[str]:
    out: List[str] = []
    n = start
    for ln in lines:
        if _RE_EMPTY.match(ln):
            out.append(ln)
            continue
        out.append(f"N{n} {ln.lstrip()}")
        n += step
    return out


def _safe_start_block(units: str, wcs: Optional[str]) -> List[str]:
    # Conservative “safe start” (ISO/Fanuc-like). Adjust as needed for your Newker model.
    unit_code = "G21" if units == "mm" else "G20"
    block = [
        "G90 G17 " + unit_code + " G40 G49 G80 G94",
    ]
    if wcs:
        block.append(wcs)
    return block


def _safe_end_block(home_end: bool) -> List[str]:
    block = [
        "M5",
        "M9",
    ]
    if home_end:
        # Generic, widely-accepted homing. Might need adaptation for your machine.
        block.extend(["G28 Z0", "G28 X0 Y0"])
    block.append("M30")
    return block


def wrap_gcode(lines: Sequence[str], opt: WrapOptions) -> List[str]:
    body = list(lines)

    if opt.strip_existing_header_footer:
        body = _strip_outer_percent(body)
        body = _strip_outer_program_number(body)
        body = _strip_trailing_m30_m2(body)

    if opt.strip_n_numbers:
        body = _strip_n_numbers(body)

    # Trim leading/trailing empty lines in body.
    while body and _RE_EMPTY.match(body[0]):
        body.pop(0)
    while body and _RE_EMPTY.match(body[-1]):
        body.pop()

    out: List[str] = []

    if opt.include_percent:
        out.append("%")

    if opt.program_style == ":":
        out.append(f":{opt.program}")
    else:
        out.append(f"O{opt.program}")

    if opt.include_comment:
        out.append(f"({opt.include_comment})")

    if opt.safe_start:
        out.extend(_safe_start_block(units=opt.units, wcs=opt.wcs))

    if body:
        out.append("")  # spacer
        out.extend(body)
        out.append("")

    if opt.safe_end:
        out.extend(_safe_end_block(home_end=opt.home_end))

    if opt.include_percent:
        out.append("%")

    if opt.renumber:
        # Renumber the whole output except the solitary '%' lines (keep them as-is).
        tmp: List[str] = []
        n = opt.renumber_start
        for ln in out:
            if _RE_EMPTY.match(ln) or _RE_PERCENT.match(ln):
                tmp.append(ln)
                continue
            tmp.append(f"N{n} {ln.lstrip()}")
            n += opt.renumber_step
        out = tmp

    return out


def _parse_args(argv: Optional[Sequence[str]] = None) -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Wrap generic G-code into a Newker-friendly program shell.")
    p.add_argument("input", type=Path, help="Input G-code / NC file")
    p.add_argument("-o", "--output", type=Path, required=True, help="Output NC file")
    p.add_argument("--program", default="1", help="Program number (digits only recommended)")
    p.add_argument(
        "--program-style",
        choices=["O", ":"],
        default="O",
        help="Program number style: 'O1234' (Fanuc-like) or ':1234' (some controllers).",
    )
    p.add_argument("--units", choices=["mm", "inch"], default="mm", help="Units for safe-start block (G21/G20).")
    p.add_argument("--wcs", default="G54", help="Work offset to output in safe-start (e.g. G54). Use '' to disable.")
    p.add_argument("--no-percent", action="store_true", help="Do not emit leading/trailing %%.")
    p.add_argument("--comment", default="NEWKER WRAPPED", help="One comment line to add after program number. Use '' to disable.")
    p.add_argument("--no-safe-start", action="store_true", help="Do not emit safe-start block (G90 G17 ...).")
    p.add_argument("--no-safe-end", action="store_true", help="Do not emit safe-end block (M5/M9/M30...).")
    p.add_argument("--home-end", action="store_true", help="Add a simple G28 home sequence before M30.")
    p.add_argument(
        "--keep-existing-header-footer",
        action="store_true",
        help="Do not strip existing %%/program/M30/M2 from the input.",
    )
    p.add_argument("--strip-n", action="store_true", help="Strip existing N-line numbers from the input.")
    p.add_argument("--renumber", action="store_true", help="Renumber output blocks with N numbers.")
    p.add_argument("--renumber-start", type=int, default=10, help="First N number (default: 10).")
    p.add_argument("--renumber-step", type=int, default=10, help="N increment (default: 10).")
    return p.parse_args(argv)


def main(argv: Optional[Sequence[str]] = None) -> int:
    ns = _parse_args(argv)

    program = ns.program.strip()
    if not program:
        raise SystemExit("--program must not be empty")

    wcs = (ns.wcs or "").strip()
    if wcs == "":
        wcs = None

    comment = (ns.comment or "").strip()
    if comment == "":
        comment = None

    opt = WrapOptions(
        program=program,
        program_style=ns.program_style,
        units=ns.units,
        wcs=wcs,
        include_percent=not ns.no_percent,
        include_comment=comment,
        safe_start=not ns.no_safe_start,
        safe_end=not ns.no_safe_end,
        home_end=bool(ns.home_end),
        strip_existing_header_footer=not ns.keep_existing_header_footer,
        strip_n_numbers=bool(ns.strip_n),
        renumber=bool(ns.renumber),
        renumber_start=int(ns.renumber_start),
        renumber_step=int(ns.renumber_step),
    )

    text = _read_text(ns.input)
    in_lines = _normalize_lines(text)
    out_lines = wrap_gcode(in_lines, opt)

    # Ensure parent exists.
    ns.output.parent.mkdir(parents=True, exist_ok=True)
    ns.output.write_text("\n".join(out_lines).rstrip() + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

