%
O9999 (Tool Measurement)

#100 =-287.344 (Machine Z sensor)
G90 G94 G17 G49 G40 G80
G21
G91 G28 Z0
G91 G28 X0 Y0
G90
M34
M82
M86

(IF [#[11000+#4120] EQ 0] GOTO 100)
(IF [#4120 EQ 0] GOTO 200)

G53 G00 Z0
G53 G00 X-11. Y-389.5

G91 G1 Z[#100+#[11000+#4120]+100] F3000
G91 G31 Z[-80] F1000

G31 G91 Z[-30.] F200.

#[11000+#4120]=[#5023-#100]

(G10 L10 P#4120 R[#5023-#100])

G91 G28 Z0.
M87
M35

G91 G28 X0. Y0.
M30

(N100)
(#3000=1(Tool zero offset. Measure Tool lenght!);)
(M30)

(N200)
(#3000=1(Tool number zero. Please tool call T# M6);)
(M30)

%