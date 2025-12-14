N10 O1234
N20 (NEWKER SHELL TEST)
N30 G90 G17 G21 G40 G49 G80 G94
N40 G54

N50 ; General Post Processor
N60 ; Machine           :
N70 ; Type              :
N80 ; SubRoutines       :
N90 ; Comp Type         : 
N100 ; Customer          : 
N110 ; Rev 1.0 :10.23.2012 : Configured post for evaluation version software.
N120 ; ---Things to do-----
N130 ;

N140 @init_post

N150 global string sUS_date sUS_time sUsrmsg sHomestr sHomestrbegin sHomestrtc sHomestrend sHomestrstpdiff sHomestrstpsame sHomeline sHomestrendsub
N160 global string sCamfilepath sSubspath cWo cPb cPe cG84 cG84p cCycs cHomep cTCcodep cTCcodes fG84spin cDr cCb cCe
N170 global logical bStartFile bTlchg bTraceUsrcall bUsrcall bSkipxyrapid bWorkoffsettc
N180 global logical bSubs bTlseperation bTcseperation bDateTimeOutput bStopM00difftool bToolPreselect bToolChangeAtEnd
N190 global logical bFromendprogram bFrombeginchangetool bFromendchangetool bFromendoffile bMultiplefixtures
N200 global logical bSafetyprep bSyncdrapid bFeedoutput bNnumtc
N210 global logical bOptstpbegin bOptstptc bOptstpend bUseprognum bUseprogname bCoolspinaftertc
N220 global logical bCoolExist bCoolofftc bSpinofftc bCooloffend bSpinoffend bG84spin bPrintloop bTest
N230 global integer iMplane iAbsincmode iWorkoffset iHeightcomp iStopmode iMotionmode iDefault_Coolant_Code
N240 global integer iDiametercomp iDrillmode iTcnumber iCoolantM iNumpecks iPworkoffset iSpindleDir
N250 global integer iSlength_g_file_name iSlength_full_g_file_name iSlengthcampartpath iDiameteroffset iArcmode
N260 global integer iHomingmode iWorkOffsetmode iProgendmode ihome_number iLhome_number
N270 global integer iCoolantM1 iCoolantM2 iCoolantM3 iCoolantM4 iCoolantM5 iCoolantM6 iCoolantM7 iCoolantM8
N280 global integer iCoolantM1ON iCoolantM2ON iCoolantM3ON iCoolantM4ON iCoolantM5ON iCoolantM6ON iCoolantM7ON iCoolantM8ON
N290 global integer iCoolantM1OFF iCoolantM2OFF iCoolantM3OFF iCoolantM4OFF iCoolantM5OFF iCoolantM6OFF iCoolantM7OFF iCoolantM8OFF
N300 global numeric nTcXnext nTcYnext nTcZnext nTcCnext nCorrectedpeck nRapidfeed

N310 global numeric  nR1pos nR1postmatrix nR1postransform nR1poscpos iR1dir nPtool_z_level nPR1pos nR1posadj nR1postemp
N320 global numeric nR1pos5x nPtool_start_plane prevFeed nLlabel
N330 global string cR1 sHomestrrot nR1pos_f bpos_f main_prog_path sTnums ;apos_f
N340 global integer iFeedType iR1posControl i4xIndexMode i4xIndexClearanceMode i4xFeedMode
N350 ; Non GPPL variables
N360 num_user_procs =    1
N370 remove_blanks = FALSE
N380 line_labels    = FALSE     ; Jump to N...
N390 clear_change_after_gen = 1

N400 ; GPPL variables
N410 numeric_def_f   = '5.4'
N420 integer_def_f   = '5.0(p)'
N430 gcode_f         = '2.0(p)'
N440 mcode_f         = '2.0(p)'
N450 xpos_f          = '5.4'
N460 ypos_f          = '5.4'
N470 zpos_f          = '5.4'
N480 nR1pos_f        = '5.3'
N490 apos_f          = '5.3'
N500 bpos_f          = '5.3'
N510 feed_f          = '4.4'
N520 blknum_f        = '5.0(p)'
N530 blknum_gen      = true
N540 bUsrcall = true
N550 call @usr_ip_useroptions
N560 bUsrcall = true
N570 call @usr_ip_postwriteroptions
N580 endp

N590 @usr_ip_useroptions
N600 ; Handle setting of options -- For users
N610 if bTraceUsrcall
N620 if bUsrcall
N630 {nl,'>>>>UserCalled @usr_ip_postwriteroptions<<<<<    '}
N640 bUsrcall = false
N650 endif
N660 endif
N670 ;Machine Definition
N680 bToolPreselect        = true      ;True = Next tool is Preselected after tool change
N690 bSyncdrapid           = true      ;True = Machine Sync's Rapid Motion (Non-Box Move)
N700 nRapidfeed            = 650.       ;Set your value for Max Feed in G1 (Used with Non-Sync'd Rapid Moves)
N710 bUseprognum           = true       ;True = Outputs Program Number
N720 bUseprogname          = true       ;True = Outputs Program Name
N730 iArcmode              = 4          ;Sets Arc Output Mode (1=AbsIJK, 2=IncIJK, 3=R 360AbsIJK, 4=R 360IncIJK)
N740 cTCcodep              = ''     ;Sets the Prefix Code(s) used for Tool Change (i.e. 'M06')
N750 cTCcodes              = 'M06 '     ;Sets the Suffix Code(s) used for Tool Change (i.e. 'M06')
N760 cWo                   = 'G'        ;Sets the Character(s) used for Work Offset (i.e. G,E,G54.1 P)
N770 iWorkOffsetmode       = 1          ;Sets the Mode used for Work Offset (1=G54, 2=E1, 3=G54.1 P1)
N780 iProgendmode          = 1          ;Sets the code for ending a program (1=M30,2=M2)
N790 cPb                   = '%'        ;Sets the Character(s) used for the beginning of file (i.e %)
N800 cPe                   = '%'        ;Sets the Character(s) used for the beginning of file (i.e %)
N810 cCb                   = '('        ;Sets the begginning Character(s) for comments
N820 cCe                   = ')'        ;Sets the ending Character(s) for comments
N830 cDr                   = 'G98 '     ;Sets the Character(s) used at the begging of a drill cycle (i.e. G98,G98,or nothing '')
N840 cG84                  = 'G84'      ;Sets the Drill Cycle Character(s) used tapping (i.e. G84, G84.1)
N850 cG84p                 = ''         ;Sets the Preperation Line used for G84 Tapping (i.e. G84.2)**FADAL setting
N860 bG84spin              = false      ;True = RPM is output during G84 Tapping Cycles
N870 fG84spin              = '5.1'      ;Sets Formatting for RPM used for G84 Tapping Cycles ('5.1' = Decimal point 1 place)
N880 cCycs                 = 'L0 '      ;Sets the Suppression Code to ignore Drill Cycles (i.e. LO)

N890 ;Coolant & Spindle Control
N900 iDefault_Coolant_Code = 8          ;Set your default Coolant type Coolant/Air/None (8=M8, 9=M9, 7=M7, etc)
N910 bCoolExist            = true       ;True = Outputs Coolant codes (Coolant,Air,Mist,etc)
N920 bCoolofftc            = true       ;True = Outputs Coolant off between Tool Changes
N930 bSpinofftc            = true       ;True = Outputs Spindle off between Tool Changes
N940 bCooloffend           = true       ;True = Outputs Coolant off at end of program
N950 bSpinoffend           = true       ;True = Outputs Spindle off at end of program
N960 bCoolspinaftertc      = false      ;True = Outputs Coolant&Spindle directly after Tool Change
N970 iCoolantM1ON          = 8           ;Code: Flood Coolant ON
N980 iCoolantM1OFF         = 9           ;Code: Flood Coolant OFF
N990 iCoolantM2ON          = 52          ;Code: Mist Coolant ON
N1000 iCoolantM2OFF         = 9           ;Code: Mist Coolant OFF
N1010 iCoolantM3ON          = 130         ;Code: HP-Flood Coolant ON
N1020 iCoolantM3OFF         = 9           ;Code: HP-Flood Coolant OFF
N1030 iCoolantM4ON          = 8           ;Code: LP-Flood Coolant ON
N1040 iCoolantM4OFF         = 9           ;Code: LP-Flood Coolant OFF
N1050 iCoolantM5ON          = 12          ;Code: High Pressure Coolant Through Tool ON
N1060 iCoolantM5OFF         = 9           ;Code: High Pressure Coolant Through Tool OFF
N1070 iCoolantM6ON          = 12          ;Code: Low Pressure Coolant Through Tool ON
N1080 iCoolantM6OFF         = 9           ;Code: Low Pressure Coolant Through Tool OFF
N1090 iCoolantM7ON          = 50          ;Code: Air Blast ON
N1100 iCoolantM7OFF         = 9           ;Code: Air Blast OFF
N1110 iCoolantM8ON          = 53          ;Code: Air through spindle ON
N1120 iCoolantM8OFF         = 9           ;Code: Air through spindle OFF

N1130 ;User Preferences
N1140 bTlseperation         = true       ;True = Seperates Tool List by blank line(s)
N1150 bTcseperation         = false       ;True = Seperates Tool Change by blank line(s)
N1160 bDateTimeOutput       = true       ;True = Outputs Date & Time
N1170 bToolChangeAtEnd      = false        ;True = Tool Change for First Tool at end of program
N1180 bOptstpbegin          = false       ;True = Outputs Optional Stop at beginning of program   !@#$%AC 0.5
N1190 bOptstptc             = true        ;True = Outputs Optional Stop between Tool Changes
N1200 bOptstpend            = false       ;True = Outputs Optional Stop at end of program
N1210 bWorkoffsettc         = true        ;True = Forces output of Work Offset at each Tool Change
N1220 bNnumtc               = true        ;True = Outputs N Numbers at Tool Changes (i.e. N1,N2,N3)
N1230 blknum_exist          = false       ;True = Outputs Line Numbers
N1240 blknum                = 100         ;Sets Starting Line Number
N1250 blknum_delta          = 1           ;Sets the delta for Line Numbers
N1260 blknum_max            = 3200000     ;Sets the maximum value for Line Numbers

N1270 ;Homing Format Definitions
N1280 ;[integer:][Prepstr :][AxisStr1 ;][AxisStrN]
N1290 ;integer = Homing Output Mode (1=G28, 2=G28 G91, 3=G53 Non-Modal, 4=G53 Modal, 5=G30, 6=G30 G91 7=G90 G54)
N1300 ;PrepStr = Sets the code(s) for the begging of line used for Homing Axis (i.e. 'G00')
N1310 ;AxisStr = Homing Axis Definition (i.e. 'Z0.0', 'H0.0 W0.')
N1320 ;Note: You can define up to 49 "Homing Lines" seperated by ";"
N1330 ;Note: Only use ";" if using more then 1 "Homing Line"
N1340 ;Note: Define string as empty '' to ignore Specific Homing Definition
N1350 sHomestrbegin         = ''	; Program Begin Homing Definition
N1360 sHomestrtc            = '2:G00 :Z0.0 '	; Tool Change Homing Definition
N1370 sHomestrend           = '2:G00 :Z0.0 ;2:G00 :B0.0 ;2:G00 :X0.0 P1 '	; Program End Homing Definition
N1380 sHomestrendsub        = '2:G00 :Z0.0 '     ; Program End Homing Definition
N1390 sHomestrstpsame       = '2:G00 :Z0.0 '	; M00 Same Tool Homing Definition
N1400 sHomestrstpdiff       = '2:G00 :Z0.0 '	; M00 Different Tool Homing Definition
N1410 sHomestrrot           = 'G00'	;Between Rotations

N1420 ; ---- 4x
N1430 iR1dir                = -1         ;1=+CCW -1=+CW
N1440 cR1                   = 'B'       ;Rotary 1 Axis
N1450 iR1posControl         = 0         ;Rotary Position Control (0=SolidCAM Direct, 1=Positive, 2=Negative, 3=Shortest Distance)
N1460 i4xIndexMode          = 1         ;4x-Indexing control (0=Simple Rotation, 1=New WorkOffset, 2=Trig Macro)
N1470 i4xIndexClearanceMode = 0         ;4x-Index Clearance control (0=Z-Homing, 1=Z-Tool_Z_Level, 2=Z-Tool_start_plane)
N1480 i4xFeedMode           = 1         ;4x-Simultanious control (0=Programed feedRate, 1=Inverse Time FeedRate, 2=Deg. per Minute)
N1490 ; ---- 4x
N1500 endp

N1510 @usr_ip_postwriteroptions
N1520 ; Handle setting of options -- For Post Writers
N1530 bSubs = false          ;True = Using sub routines, False = Not using sub routines
N1540 ; ------Below are tracing functions-----
N1550 ; trace "all":5
N1560 ; trace "@change_tool":5
N1570 ; trace "@def_tool":5
N1580 ; trace "@tmatrix":5
N1590 ; bTraceUsrcall = True  ;Trace UserCalls to procedures
N1600 endp

N1610 ;-------------------

N1620 @start_of_file
N1630 ; Handle what is output at the start of the file
N1640 ; This is the first procedure called (lie...@init_post is actually first)
N1650 ;    sCamfilepath = tostr(program_number)
N1660 ;    {nl,'!!open file=' 'O' + sCamfilepath'!!'}
N1670 ;    {nl}
N1680 if iNumber_of_Fixtures > 1
N1690 bMultiplefixtures = true
N1700 blknum_exist    = false
N1710 endif
N1720 call @usr_campart_path
N1730 call @usr_init_gmstates
N1740 call @usr_sof_character
N1750 call @usr_sof_progname
N1760 call @usr_sof_commentsbeforecodes
N1770 call @usr_sof_gmcodes
N1780 call @usr_sof_commentsaftercodes

N1790 {nl,cCb'MACHINE; TOYODA FH1250'cCe}
N1800 if PartNumber ne ''
N1810 {NL,'(PART NUMBER; ',PartNumber,')'}
N1820 endif
N1830 if Revision ne ''
N1840 {NL,'(REVISION; ',Revision,')'}
N1850 endif
N1860 if message1 ne ''
N1870 {nl}
N1880 {nl,'(NOTES;)'}
N1890 {nl}
N1900 {NL,'(',message1,')'}
N1910 endif
N1920 if message2 ne ''
N1930 {NL,'(',message2,')'}
N1940 endif
N1950 if message3 ne ''
N1960 {NL,'(',message3,')'}
N1970 endif
N1980 if message4 ne ''
N1990 {NL,'(',message4,')'}
N2000 endif
N2010 if message5 ne ''
N2020 {NL,'(',message5,')'}
N2030 endif
N2040 if message6 ne ''
N2050 {NL,'(',message6,')'}
N2060 endif
N2070 if message7 ne ''
N2080 {NL,'(',message7,')'}
N2090 endif
N2100 if message8 ne ''
N2110 {NL,'(',message8,')'}
N2120 endif
N2130 if message9 ne ''
N2140 {NL,'(',message9,')'}
N2150 endif
N2160 if message10 ne ''
N2170 {NL,'(',message10,')'}
N2180 endif
N2190 {nl}
N2200 bStartFile = true
N2210 iLhome_number = home_number
N2220 endp

N2230 @usr_sof_character
N2240 ; Handle start of file character
N2250 if cPb ne ''
N2260 {cPb}
N2270 endif
N2280 endp

N2290 @usr_sof_progname
N2300 ; Handle Program Number and/or Name
N2310 if bUseprognum
N2320 {nl, 'O'(program_number)}
N2330 if bUseprogname
N2340 {' 'cCb,PartNumber,' ; REV ',Revision,' ; FH1250'cCe}
N2350 endif
N2360 else
N2370 if bUseprogname
N2380 {nl, cCb, part_name,cCe}
N2390 endif
N2400 endif
N2410 endp

N2420 @usr_sof_commentsbeforecodes
N2430 ; Handle HardCoded or PartControlled comments ~Before gmcodes~
N2440 {nl}
N2450 call @usr_US_date
N2460 call @usr_US_time
N2470 if bDateTimeOutput
N2480 {nb,cCb,'PROGRAMMED; 'sUS_date'-'sUS_time,cCe}
N2490 endif
N2500 endp

N2510 @usr_sof_gmcodes
N2520 ; Handle HardCoded or PartControlled G/M codes
N2530 endp

N2540 @usr_sof_commentsaftercodes
N2550 ; Handle HardCoded or UserDefined comments (After G/M codes)
N2560 endp

N2570 @usr_US_date
N2580 ; Converts Europe Date format to US format
N2590 Local Integer iInt1
N2600 iInt1 = instr(date,'-')
N2610 sUS_date = substr(date,(iInt1+1),3) + '-' + substr(date,1,(iInt1-1)) + '-' + right(date,4)
N2620 endp

N2630 @usr_US_time
N2640 ; Converts Military time to 12hr format
N2650 Local Integer iInt1 iHr_Mil_int iHour
N2660 Local String iHr_Mil iTm_of_day
N2670 iInt1 = instr(time,':')
N2680 iHr_Mil = left(time,(iInt1-1))
N2690 iHr_Mil_int = tonum(iHr_Mil)
N2700 if iHr_Mil_int < 12
N2710 if iHr_Mil_int < 1
N2720 iHour = 12
N2730 else
N2740 iHour = iHr_Mil_int
N2750 endif
N2760 iTm_of_day = 'AM'
N2770 else
N2780 if iHr_Mil_int < 13
N2790 iHour = 12
N2800 else
N2810 iHour = iHr_Mil_int - 12
N2820 endif
N2830 iTm_of_day = 'PM'
N2840 endif
N2850 sUS_time = tostr(iHour:'5.0(p)') + substr(time,iInt1,8) + iTm_of_day
N2860 endp

N2870 @usr_init_gmstates
N2880 ; Handle initializing gmcodes for correct modality from beginning of file
N2890 iMplane         = 9999
N2900 iAbsincmode     = 9999
N2910 iWorkoffset     = 9999
N2920 iHeightcomp     = 9999
N2930 iMotionmode     = 9999
N2940 iDiametercomp   = 9999
N2950 iDiameteroffset = 9999
N2960 iDrillmode      = 9999
N2970 iTcnumber       = 0
N2980 iCoolantM1      = iCoolantM1OFF
N2990 iCoolantM2      = iCoolantM2OFF
N3000 iCoolantM3      = iCoolantM3OFF
N3010 iCoolantM4      = iCoolantM4OFF
N3020 iCoolantM5      = iCoolantM5OFF
N3030 iCoolantM6      = iCoolantM6OFF
N3040 iCoolantM7      = iCoolantM7OFF
N3050 iCoolantM8      = iCoolantM8OFF
N3060 ; ---- 4x
N3070 nR1pos          = 9999
N3080 iFeedType       = 94
N3090 ; ---- 4x
N3100 endp

N3110 ;-------------------

N3120 @def_tool
N3130 ; Handle Tool List Output at top of progam
N3140 ; Use bTlchg to use different message for tool_change
N3150 if tool_message == '' then
N3160 {nb, cCb'TOOL 'tool_number, '   DIA '(tool_offset*2),cCe }
N3170 else
N3180 {nb,cCb'T'tool_number,' ' tool_message,cCe}
N3190 if msg_mill_tool1 ne ''
N3200 {nb,cCb'---' msg_mill_tool1,cCe}
N3210 endif
N3220 if msg_mill_tool2 ne ''
N3230 {nb,cCb'---' msg_mill_tool2,cCe}
N3240 endif
N3250 if msg_mill_tool3 ne ''
N3260 {nb,cCb'---' msg_mill_tool3,cCe}
N3270 endif
N3280 if msg_mill_tool4 ne ''
N3290 {nb,cCb'---' msg_mill_tool4,cCe}
N3300 endif
N3310 if msg_mill_tool5 ne ''
N3320 {nb,cCb'---' msg_mill_tool5,cCe}
N3330 endif
N3340 endif
N3350 if next_command ne '@def_tool' and bTlchg eq false
N3360 if bTlseperation
N3370 {nl}
N3380 endif
N3390 if bOptstpbegin
N3400 call @usr_optionalstop
N3410 endif

N3420 endif
N3430 endp

N3440 ;-------------------

N3450 @start_program
N3460 ; Handle any safety gmcodes for top of program
N3470 ;	{nb}
N3480 ;	call @usr_abs_inc_output
N3490 ;	call @usr_mp_output
N3500 ;	side = COMP_OFF
N3510 ;	call @compensation
N3520 ;	call @usr_compensation_output
N3530 ;	skipline = false
N3540 ;	call @end_drill
N3550 ;	;{'G49 '}
N3560 ;	{'G21'}
N3570 if sHomestrbegin ne ''
N3580 sHomestr = sHomestrbegin
N3590 call @usr_prep_home_axis
N3600 endif
N3610 ;call @usr_optionalstop  ; !@#$%AC 0.5
N3620 endp

N3630 ;-------------------

N3640 @end_program
N3650 ; Handle output for end of program
N3660 if bMultiplefixtures eq True
N3670 bFromendprogram = True
N3680 call @Multiple_Fixtures
N3690 endif
N3700 if bCooloffend and bCoolExist
N3710 iCoolantM1 = iCoolantM1OFF
N3720 iCoolantM2      = iCoolantM2OFF
N3730 iCoolantM3      = iCoolantM3OFF
N3740 iCoolantM4      = iCoolantM4OFF
N3750 iCoolantM5      = iCoolantM5OFF
N3760 iCoolantM6      = iCoolantM6OFF
N3770 iCoolantM7      = iCoolantM7OFF
N3780 iCoolantM8      = iCoolantM8OFF
N3790 call @usr_coolant_output
N3800 endif
N3810 if bSpinoffend
N3820 iSpindleDir = 5
N3830 {nb}
N3840 call @usr_spindle_mcode_output
N3850 endif
N3860 if sHomestrend ne ''
N3870 sHomestr = sHomestrend
N3880 call @usr_prep_home_axis
N3890 endif
N3900 ;    if change(iAbsincmode)
N3910 ;	    {nb}
N3920 ;	    call @usr_abs_inc_output
N3930 ;    endif
N3940 if change(iWorkoffset)
N3950 {nb}
N3960 call @usr_homenumber_output
N3970 endif
N3980 if bOptstpend
N3990 call @usr_optionalstop
N4000 endif
N4010 if bToolChangeAtEnd
N4020 {nb,'T'tool_number}
N4030 {nb,cTCcodep}
N4040 {nb,'T'next_tool_number}
N4050 endif
N4060 if iProgendmode eq 1
N4070 {nb, 'G90'}
N4080 {nb, 'M30 '}
N4090 endif
N4100 if iProgendmode eq 2
N4110 {nb, 'G90'}
N4120 {nb, 'M2 '}
N4130 endif

N4140 endp

N4150 ;-------------------

N4160 @end_of_file
N4170 ; Handle end of file character
N4180 if i4xIndexMode eq 2 and !bLimit_3axis ;Trig Macro
N4190 call @usr_trig_macro_output
N4200 endif
N4210 if cPe ne ''
N4220 {nl,cPb}
N4230 endif
N4240 if bMultiplefixtures eq True
N4250 bFromendoffile = True
N4260 call @Multiple_Fixtures
N4270 endif
N4280 endp

N4290 ;-------------------

N4300 @relative_mode
N4310 ; Handle setting of IncrementalMode Gcode
N4320 iAbsincmode = 91
N4330 endp

N4340 @absolute_mode
N4350 ; Handle setting of AbsoluteMode Gcode
N4360 iAbsincmode = 90
N4370 endp

N4380 @usr_abs_inc_output
N4390 ; Handle output of AbsoluteMode Gcode
N4400 {['G'iAbsincmode, ' ']}
N4410 if change(iAbsincmode); !@#$% Force !change for variable
N4420 change(iAbsincmode) = false
N4430 endif
N4440 endp

N4450 ;-------------------

N4460 @machine_plane
N4470 ; Handle GPP direct call to @machine_plane
N4480 ; We not use this procedure to output code
N4490 ; We create our own procedure for this so that we may Sync with arc_zx_yz
N4500 if machine_plane eq XY
N4510 iMplane = 17
N4520 endif
N4530 if machine_plane eq ZX
N4540 iMplane = 18
N4550 endif
N4560 if machine_plane eq YZ
N4570 iMplane = 19
N4580 endif
N4590 endp

N4600 @usr_mp_output
N4610 ; Handle output of MachinePlane Gcode
N4620 ; Use bStartFile variable to ignore this output at beginning of file
N4630 {['G'iMplane' ']}
N4640 if change(iMplane); !@#$% Force !change for variable
N4650 change(iMplane) = false
N4660 endif
N4670 endp

N4680 ;-------------------

N4690 @home_number
N4700 ; Handle setting WorkOffset Gcode
N4710 if part_home_number eq 20
N4720 ihome_number = iLhome_number
N4730 else
N4740 iLhome_number = part_home_number
N4750 ihome_number = part_home_number
N4760 endif
N4770 if iWorkOffset_Method eq 0
N4780 if iWorkOffsetmode eq 1
N4790 if part_home_number <= 6
N4800 cWo = 'G'
N4810 if i4xIndexMode eq 0
N4820 iWorkoffset = 53 + mac_number              ; uncoment this line for same work offset number for all positions
N4830 else
N4840 iWorkoffset = 53 + part_home_number    ; uncoment this line for different work offset number for all positions
N4850 endif
N4860 else
N4870 cWo = 'G54.1 p'
N4880 iWorkoffset = part_home_number - 6
N4890 endif
N4900 else
N4910 if iWorkOffsetmode eq 2 or iWorkOffsetmode eq 3
N4920 iWorkoffset = part_home_number
N4930 endif
N4940 endif
N4950 else
N4960 iWorkoffset = tonum(home_user_name)
N4970 endif
N4980 endp

N4990 @usr_homenumber_output
N5000 ; Handle output WorkOffset Gcode
N5010 {[cWo,iWorkoffset' ']}
N5020 if change(iWorkoffset); !@#$% Force !change for variable
N5030 change(iWorkoffset) = false
N5040 endif
N5050 endp

N5060 ;-------------------

N5070 @change_tool
N5080 ; Delayed Tool Change handling to @start_of_job to have access to Operation(Job) data
N5090 nTcXnext = xnext
N5100 nTcYnext = ynext
N5110 nTcZnext = tool_start_plane
N5120 nTcCnext = cnext
N5130 bTlchg = true
N5140 if first_tool
N5150 sTnums = tostr(tool_number)
N5160 endif
N5170 endp

N5180 @usr_ct
N5190 ; Handle all aspects of Tool Change
N5200 local integer count i
N5210 local string tTnums
N5220 if bMultiplefixtures eq True
N5230 bFrombeginchangetool = True
N5240 call @Multiple_Fixtures
N5250 endif
N5260 iTcnumber = iTcnumber + 1
N5270 tTnums = sTnums
N5280 ;    if !first_tool
N5290 ;        count = 0
N5300 ;        i = 2
N5310 ;        while i > 1
N5320 ;            i = instr(tTnums,tostr(tool_number)) + 1
N5330 ;            tTnums = substr(tTnums,i,99)
N5340 ;            count = count + 1
N5350 ;        endw
N5360 ;        sTnums = sTnums + tostr(tool_number)
N5370 ;        iTcnumber = (tool_number * 100) + count
N5380 ;    else
N5390 ;        iTcnumber = (tool_number * 100) + 1
N5400 ;    endif
N5410 bStartFile = false
N5420 if !first_tool
N5430 call @usr_ct_before_notfirsttool
N5440 endif
N5450 if first_tool
N5460 call @usr_ct_before_firsttool
N5470 endif
N5480 call @usr_ct_toolchange
N5490 call @usr_tc_init_gmstates
N5500 call @usr_ct_after
N5510 if !bMultiplefixtures and !Bsubs
N5520 ;		bSkipxyrapid = true
N5530 endif
N5540 if bMultiplefixtures eq True
N5550 bFromendchangetool = True
N5560 call @Multiple_Fixtures
N5570 endif
N5580 endp

N5590 @usr_ct_before_notfirsttool
N5600 ; Handle output before the next tool change
N5610 ; This is not called before the first tool change
N5620 local integer i poz1 l1b pr1
N5630 local string msg1 msg1a msg1b
N5640 if !bStopM00difftool
N5650 if bCooloffend and bCoolExist
N5660 iCoolantM1 = iCoolantM1OFF
N5670 iCoolantM2 = iCoolantM2OFF
N5680 iCoolantM3 = iCoolantM3OFF
N5690 iCoolantM4 = iCoolantM4OFF
N5700 iCoolantM5 = iCoolantM5OFF
N5710 iCoolantM6 = iCoolantM6OFF
N5720 iCoolantM7 = iCoolantM7OFF
N5730 iCoolantM8 = iCoolantM8OFF
N5740 call @usr_coolant_output
N5750 endif
N5760 if bSpinoffend
N5770 iSpindleDir = 5
N5780 {nb}
N5790 call @usr_spindle_mcode_output
N5800 endif
N5810 if sHomestrtc ne ''
N5820 sHomestr = sHomestrtc
N5830 call @usr_prep_home_axis
N5840 endif
N5850 if bOptstptc
N5860 {nb}
N5870 call @usr_optionalstop
N5880 endif
N5890 if bNnumtc
N5900 {nb}
N5910 {nl,'N'iTcnumber' '}
N5920 endif
N5930 {nb, cCb,job_name,cCe}
N5940 if msg ne ''
N5950 i = 1
N5960 while i < 50
N5970 i = i + 1
N5980 poz1=instr(msg,'\n')
N5990 if poz1 eq 0
N6000 poz1=strlen(msg)
N6010 msg1=msg
N6020 else
N6030 poz1 = poz1-2
N6040 msg1=left(msg,poz1)
N6050 endif
N6060 {nb, cCb,msg1,cCe}
N6070 poz1=instr(msg,'\n')
N6080 if poz1 eq 0
N6090 i = 51
N6100 else
N6110 l1b=strlen(msg)-strlen(msg1)
N6120 pr1=poz1+1
N6130 msg1b=substr(msg,pr1,l1b)
N6140 msg=msg1b
N6150 endif
N6160 endw
N6170 endif
N6180 endif
N6190 if bTcseperation
N6200 {nl}
N6210 endif
N6220 ;	bSafetyprep = true
N6230 call @usr_tc_init_gmstates
N6240 ;	call @usr_abs_inc_output
N6250 call @usr_mp_output
N6260 ;	call @usr_compensation_output
N6270 ;	skipline = false
N6280 ;	call @end_drill
N6290 ;	{'G00 '}
N6300 endp

N6310 @usr_ct_before_firsttool
N6320 ; Handle output before the first tool change
N6330 local integer i poz1 l1b pr1
N6340 local string msg1 msg1a msg1b
N6350 {nl}
N6360 if bNnumtc
N6370 {nl,'N'iTcnumber' '}
N6380 endif
N6390 {nb, cCb,job_name,cCe}
N6400 if msg ne ''
N6410 i = 1
N6420 while i < 50
N6430 i = i + 1
N6440 poz1=instr(msg,'\n')
N6450 if poz1 eq 0
N6460 poz1=strlen(msg)
N6470 msg1=msg
N6480 else
N6490 poz1 = poz1-2
N6500 msg1=left(msg,poz1)
N6510 endif
N6520 {nb, cCb,msg1,cCe}
N6530 poz1=instr(msg,'\n')
N6540 if poz1 eq 0
N6550 i = 51
N6560 else
N6570 l1b=strlen(msg)-strlen(msg1)
N6580 pr1=poz1+1
N6590 msg1b=substr(msg,pr1,l1b)
N6600 msg=msg1b
N6610 endif
N6620 endw
N6630 endif
N6640 if sHomestrtc ne ''
N6650 sHomestr = sHomestrtc
N6660 call @usr_prep_home_axis
N6670 endif
N6680 endp

N6690 @usr_ct_toolchange
N6700 ; Handle G/M code output to make tool change
N6710 {nb,'T'tool_number}
N6720 if tool_message == '' then
N6730 {' ' cCb'TOOL 'tool_number, ' - DIA '(tool_offset*2),cCe }
N6740 else
N6750 {' ' cCb tool_message,cCe}
N6760 endif
N6770 {nb,cTCcodes}
N6780 endp

N6790 @usr_ct_after
N6800 ; Handle output after tool change
N6810 ; *Note: Coolant & job Options need handling
N6820 ; ---- 4x
N6830 ;	if i4xIndexMode eq 2 and !bLimit_3axis ;Trig Macro
N6840 ;		call @usr_r1pos_calc
N6850 ;		call @usr_trig_macro_call
N6860 ;		iWorkoffset = 112
N6870 ;		nR1pos = 9999
N6880 ;	endif
N6890 ; ---- 4x
N6900 imotionmode = 0
N6910 {nb, 'G'iMotionmode:mcode_f ' '}
N6920 call @machine_plane
N6930 change(implane) = true
N6940 call @usr_mp_output
N6950 {'G21 '}
N6960 skipline = false
N6970 call @usr_heightcomp_off
N6980 skipline = false
N6990 iDrillmode = 9999
N7000 call @end_drill
N7010 imotionmode = 0
N7020 change(	imotionmode) = false
N7030 call @usr_abs_inc_output
N7040 skipline = true
N7050 if bCoolspinaftertc
N7060 skipline = true
N7070 call @start_tool
N7080 if bCoolExist
N7090 skipline = true
N7100 call @usr_coolant
N7110 endif
N7120 xpos = nTcXnext
N7130 ypos = nTcYnext
N7140 cpos = nTcCnext
N7150 change(xpos) = true
N7160 change(ypos) = true
N7170 change(cpos) = true
N7180 change(zpos) = false
N7190 call @usr_rapid
N7200 call @usr_heightcomp_on
N7210 else
N7220 xpos = nTcXnext
N7230 ypos = nTcYnext
N7240 cpos = nTcCnext
N7250 change(xpos) = false
N7260 change(ypos) = false
N7270 change(cpos) = true
N7280 change(zpos) = false
N7290 call @usr_rapid
N7300 change(xpos) = true
N7310 change(ypos) = true
N7320 change(cpos) = false
N7330 change(zpos) = false
N7340 call @usr_rapid
N7350 skipline = false
N7360 call @start_tool
N7370 call @usr_heightcomp_on
N7380 if bCoolExist
N7390 skipline = false
N7400 call @usr_coolant
N7410 endif
N7420 endif
N7430 if bToolPreselect
N7440 {nb,'T'next_tool_number}
N7450 endif
N7460 endp

N7470 @usr_tc_init_gmstates
N7480 ; Handle initializing gmcodes for correct modality after tool change
N7490 if first_tool
N7500 iMotionmode = 9999
N7510 iDiametercomp = 40
N7520 change(iAbsincmode) = true
N7530 change(iWorkoffset) = true
N7540 change(iDiameteroffset) = false
N7550 iHeightcomp = 9999
N7560 iDrillmode = 9999
N7570 iCoolantM1 = iCoolantM1OFF
N7580 iCoolantM2 = iCoolantM2OFF
N7590 iCoolantM3 = iCoolantM3OFF
N7600 iCoolantM4 = iCoolantM4OFF
N7610 iCoolantM5 = iCoolantM5OFF
N7620 iCoolantM6 = iCoolantM6OFF
N7630 iCoolantM7 = iCoolantM7OFF
N7640 iCoolantM8 = iCoolantM8OFF
N7650 else
N7660 if bSafetyprep
N7670 call @machine_plane
N7680 change(iMplane) = true
N7690 change(iAbsincmode) = true
N7700 change(iDiametercomp) = true
N7710 ;iDrillmode = 9999  !@#$%AC
N7720 bSafetyprep = false
N7730 else
N7740 iMotionmode = 9999
N7750 if bWorkoffsettc
N7760 change(iWorkoffset) = true
N7770 endif
N7780 change(iAbsincmode) = true
N7790 iDiametercomp = 40
N7800 change(iDiameteroffset) = false
N7810 iHeightcomp = 9999
N7820 ;iDrillmode = 9999   !@#$%AC
N7830 iCoolantM1 = iCoolantM1OFF
N7840 iCoolantM2 = iCoolantM2OFF
N7850 iCoolantM3 = iCoolantM3OFF
N7860 iCoolantM4 = iCoolantM4OFF
N7870 iCoolantM5 = iCoolantM5OFF
N7880 iCoolantM6 = iCoolantM6OFF
N7890 iCoolantM7 = iCoolantM7OFF
N7900 iCoolantM8 = iCoolantM8OFF
N7910 change(nRapidfeed) = true
N7920 ; ---- 4x
N7930 nR1pos = 9999
N7940 ; ---- 4x
N7950 endif
N7960 endif
N7970 endp

N7980 @usr_heightcomp_on
N7990 ; Handle line to turn on Height Compensation (Typically after tool change)
N8000 iHeightcomp = 43
N8010 {nb, 'G'iHeightcomp, ' H'tool_number' '}
N8020 skipline = false
N8030 zpos = nTcZnext
N8040 change(xpos) = false
N8050 change(ypos) = false
N8060 call @rapid_move
N8070 endp

N8080 @usr_heightcomp_off
N8090 ; Handle line to turn off Height Compensation (Typically don't use)
N8100 iHeightcomp = 49
N8110 if change(iHeightcomp)
N8120 {nb, 'G'iHeightcomp' '}
N8130 endif
N8140 endp

N8150 @usr_coolant
N8160 ; Handle setting of coolant variable
N8170 ; When GlobalCode = 0, we use UserOption for thier default CoolantCode
N8180 ;  *Note: PartOptions default to 0 in SolidCAM
N8190 ;  *Note: Some customers default with M8(coolant), but some use M7(air) or M9(nothing)
N8200 ; We use GlobalCode for coolant unless
N8210 ;  the user inputs a number for LocalCode (Misc Params--Operation)
N8220 if flood_coolant eq 1
N8230 iCoolantM1 = iCoolantM1ON
N8240 endif
N8250 if flood_coolant eq 0 or flood_coolant eq 2
N8260 iCoolantM1 = iCoolantM1OFF
N8270 endif
N8280 if Mist_coolant eq 1
N8290 iCoolantM2 = iCoolantM2ON
N8300 endif
N8310 if Mist_coolant eq 0 or Mist_coolant eq 2
N8320 iCoolantM2 = iCoolantM2OFF
N8330 endif
N8340 if HP_Flood_coolant eq 1
N8350 iCoolantM3 = iCoolantM3ON
N8360 endif
N8370 if HP_Flood_coolant eq 0 or HP_Flood_coolant eq 2
N8380 iCoolantM3 = iCoolantM3OFF
N8390 endif
N8400 if LP_Flood_coolant eq 1
N8410 iCoolantM4 = iCoolantM4ON
N8420 endif
N8430 if LP_Flood_coolant eq 0 or LP_Flood_coolant eq 2
N8440 iCoolantM4 = iCoolantM4OFF
N8450 endif
N8460 if Through_coolant eq 1
N8470 iCoolantM5 = iCoolantM5ON
N8480 endif
N8490 if Through_coolant eq 0 or Through_coolant eq 2
N8500 iCoolantM5 = iCoolantM5OFF
N8510 endif
N8520 if LP_Through_coolant eq 1
N8530 iCoolantM6 = iCoolantM6ON
N8540 endif
N8550 if LP_Through_coolant eq 0 or LP_Through_coolant eq 2
N8560 iCoolantM6 = iCoolantM6OFF
N8570 endif
N8580 if Air_Blast_coolant eq 1
N8590 iCoolantM7 = iCoolantM7ON
N8600 endif
N8610 if Air_Blast_coolant eq 0 or Air_Blast_coolant eq 2
N8620 iCoolantM7 = iCoolantM7OFF
N8630 endif
N8640 if air_through_coolant eq 1
N8650 iCoolantM8 = iCoolantM8ON
N8660 endif
N8670 if air_through_coolant eq 0 or air_through_coolant eq 2
N8680 iCoolantM8 = iCoolantM8OFF
N8690 endif
N8700 call @usr_coolant_output
N8710 endp

N8720 @usr_coolant_output
N8730 ; Handle output of coolant variable
N8740 if change(iCoolantM1)
N8750 {nb,['M'iCoolantM1:mcode_f' ']}
N8760 if iCoolantM1 eq iCoolantM1OFF
N8770 change(iCoolantM2) = false
N8780 change(iCoolantM3) = false
N8790 change(iCoolantM4) = false
N8800 change(iCoolantM5) = false
N8810 change(iCoolantM6) = false
N8820 change(iCoolantM7) = false
N8830 endif
N8840 endif
N8850 if change(iCoolantM2)
N8860 {nb,['M'iCoolantM2:mcode_f' ']}
N8870 if iCoolantM2 eq iCoolantM2OFF
N8880 change(iCoolantM3) = false
N8890 change(iCoolantM4) = false
N8900 change(iCoolantM5) = false
N8910 change(iCoolantM6) = false
N8920 change(iCoolantM7) = false
N8930 endif
N8940 endif
N8950 if change(iCoolantM3)
N8960 {nb,['M'iCoolantM3:mcode_f' ']}
N8970 if iCoolantM3 eq iCoolantM3OFF
N8980 change(iCoolantM4) = false
N8990 change(iCoolantM5) = false
N9000 change(iCoolantM6) = false
N9010 change(iCoolantM7) = false
N9020 endif
N9030 endif
N9040 if change(iCoolantM4)
N9050 {nb,['M'iCoolantM4:mcode_f' ']}
N9060 if iCoolantM4 eq iCoolantM4OFF
N9070 change(iCoolantM5) = false
N9080 change(iCoolantM6) = false
N9090 change(iCoolantM7) = false
N9100 endif
N9110 endif
N9120 if change(iCoolantM5)
N9130 {nb,['M'iCoolantM5:mcode_f' ']}
N9140 if iCoolantM5 eq iCoolantM5OFF
N9150 change(iCoolantM6) = false
N9160 change(iCoolantM7) = false
N9170 endif
N9180 endif
N9190 if change(iCoolantM6)
N9200 {nb,['M'iCoolantM6:mcode_f' ']}
N9210 if iCoolantM6 eq iCoolantM6OFF
N9220 change(iCoolantM7) = false
N9230 endif
N9240 endif
N9250 if change(iCoolantM7)
N9260 {nb,['M'iCoolantM7:mcode_f' ']}
N9270 endif
N9280 if change(iCoolantM8)
N9290 {nb,['M'iCoolantM8:mcode_f' ']}
N9300 endif
N9310 if  !change(iCoolantM1) or  !change(iCoolantM2) or !change(iCoolantM3) or  !change(iCoolantM4) or !change(iCoolantM5) or  !change(iCoolantM6) or !change(iCoolantM7) or !change(iCoolantM8)
N9320 skipline = TRUE
N9330 endif
N9340 endp
N9350 ;--------------------

N9360 @start_of_job
N9370 ; Handle what happens at start of operation(job)
N9380 ; If using Subs we do not make tool change in @start_of_job
N9390 call @home_number
N9400 if rot_axis_type ne axis4_none
N9410 Xpos = 0
N9420 Xnext = 0
N9430 nTcXnext = 0
N9440 endif
N9450 if bSubs
N9460 {nb, cCb,job_name,cCe}
N9470 change(xpos) = true
N9480 change(ypos) = true
N9490 change(cpos) = true
N9500 change(nr1pos) = true
N9510 else
N9520 if bTlchg
N9530 call @usr_ct
N9540 bTlchg = false
N9550 else
N9560 {nb}
N9570 if bNnumtc
N9580 sTnums = sTnums + tostr(tool_number:'2/2.0')
N9590 iTcnumber = iTcnumber + 1
N9600 {nl,'N' iTcnumber' '}
N9610 else
N9620 {nb}
N9630 endif
N9640 {nb, cCb,job_name,cCe}
N9650 ; ---- 4x
N9660 ;   - Set Rotary Position
N9670 call @usr_r1pos_calc
N9680 if change(nR1pos)
N9690 if sHomestrrot ne ''
N9700 sHomestr = sHomestrrot
N9710 call @usr_prep_home_axis
N9720 else
N9730 iMotionmode = 0
N9740 change(iMotionmode) = true
N9750 {nb,['G'iMotionmode:mcode_f ' '],['Z'tool_z_level ' ']}
N9760 endif
N9770 iMotionmode = 0
N9780 change(iMotionmode) = true
N9790 xpos = xnext
N9800 ypos = ynext
N9810 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],['G'iAbsincmode ' '],[cWo,iWorkoffset' '],['X'xpos ' '],['Y'ypos ' ']}
N9820 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],['G'iAbsincmode ' '],[cWo,iWorkoffset' '],[cR1,nR1pos ' ']}
N9830 change(iMotionmode) = false
N9840 change(iMplane) = false
N9850 change(iWorkoffset) = false
N9860 change(iAbsincmode) = false
N9870 change(nR1pos) = false
N9880 change(xpos) = FALSE
N9890 change(ypos) = FALSE
N9900 change(zpos) = false
N9910 ;				bSkipxyrapid = true
N9920 endif
N9930 endif
N9940 endif
N9950 if job_type eq 'drill_hr' or X5_job or transform_type eq 3
N9960 bSkipxyrapid = false
N9970 endif
N9980 if bCoolExist and !bsubs
N9990 skipline = TRUE
N10000 call @usr_coolant
N10010 endif
N10020 endp

N10030 ;--------------------

N10040 @end_of_job
N10050 ; Handle what happens at end of operation(job)
N10060 ; If using Subs we do not make tool change in @start_of_job
N10070 if bStopM00
N10080 if tool_number eq next_job_tool_number
N10090 call @usr_StopM00_sametool
N10100 else
N10110 call @usr_StopM00_difftool
N10120 endif
N10130 endif
N10140 bSkipxyrapid = false
N10150 bStopM00difftool = false
N10160 iPworkoffset = iWorkoffset
N10170 ; ---- 4x
N10180 ;if tool_z_level < tool_start_plane
N10190 ;    Print 'WARNING!! Tool Z Level is below Tool Start Plane in CoordSys'
N10200 ;    {nl,'WARNING!! Tool Z Level is below Tool Start Plane in CoordSys'}
N10210 ;endif
N10220 nPtool_z_level = tool_z_level
N10230 nPtool_start_plane = tool_start_plane
N10240 cpos = 0
N10250 apos = 0
N10260 ; ---- 4x
N10270 ;    if bCoolExist and !bsubs
N10280 ;	    call @usr_coolant
N10290 ;    endif
N10300 endp

N10310 ;-------------------

N10320 @rapid_move
N10330 ; Handle GPP direct call to Rapid Move (G00)
N10340 ; We not use this procedure to output code
N10350 ; We create our own procedure for this so that we may...
N10360 ;   Sync with @rapid_move, @move_5x, @move_4x, @move4x_polar, @move4x_cartesian
N10370 call @usr_rapid
N10380 endp

N10390 @usr_rapid
N10400 ; Handle output for Rapid Move (G00)
N10410 ; Note: XYZ not allowed together on a single line
N10420 ; ---- 4x
N10430 ;   - Set Rotary Position
N10440 call @usr_r1pos_calc
N10450 if change(cpos) and !change(xpos) and !change(ypos) and !change(zpos) and !change(nR1pos) ;Ignore cpos prepositioning, handled at toolchange
N10460 skipline = false
N10470 endif
N10480 ; ---- 4x
N10490 if !bSkipxyrapid
N10500 if !bSyncdrapid
N10510 if job_type eq '3-d model'
N10520 iMotionmode = 1
N10530 else
N10540 iMotionmode = 0
N10550 endif
N10560 else
N10570 iMotionmode = 0
N10580 endif
N10590 if (change(xpos)or change(ypos)) and change(zpos) ;!@#$% clear change
N10600 bTest = true
N10610 endif
N10620 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],['G'iAbsincmode ' '],[cWo,iWorkoffset' '],['X'xpos ' '],['Y'ypos ' '],[cR1,nR1pos ' ']}
N10630 change(cWo) = false
N10640 change(cR1) = false
N10650 if change(zpos)
N10660 if bTest  ;!@#$% clear change
N10670 {nb,['Z'zpos ' ']}
N10680 bTest = false
N10690 else
N10700 {'Z'zpos ' '}
N10710 endif
N10720 endif
N10730 if !bSyncdrapid
N10740 if job_type eq '3-d model'
N10750 {['F'nRapidfeed' ']}
N10760 endif
N10770 endif
N10780 bSkipxyrapid = false
N10790 else
N10800 {nb,['Z'zpos ' ']}
N10810 if !bSyncdrapid
N10820 if job_type eq '3-d model'
N10830 {['F'nRapidfeed' ']}
N10840 endif
N10850 endif
N10860 bSkipxyrapid = false
N10870 endif
N10880 if change(iMotionmode)
N10890 change(iMotionmode) = false
N10900 endif
N10910 if change(iMplane)
N10920 change(iMplane) = false
N10930 endif
N10940 if change(iWorkoffset)
N10950 change(iWorkoffset) = false
N10960 endif
N10970 if change(iAbsincmode)
N10980 change(iAbsincmode) = false
N10990 endif
N11000 if change(nRapidfeed)
N11010 change(nRapidfeed) = false
N11020 endif
N11030 if !bSyncdrapid
N11040 bFeedoutput        = true
N11050 endif
N11060 endp

N11070 ;-------------------

N11080 @line
N11090 ; Handle GPP direct call to Line Movement (G01)
N11100 ; We not use this procedure to output code
N11110 ; We create our own procedure for this so that we may...
N11120 ;   Sync with @line, @line_5x, @line_4x, @line4x_polar, @line4x_cartesian
N11130 call @usr_line
N11140 endp

N11150 @usr_line
N11160 ; Handle output for line movement (G01)
N11170 ; ---- 4x
N11180 ;   - Set Rotary Position
N11190 call @usr_r1pos_calc
N11200 if rot_axis_type ne axis4_none or X5_job
N11210 ;iFeedType = 93  ;Inverse Feed
N11220 ;feed = (1/(inverse_feed))
N11230 ;if tool_path_type eq 'start_approach'
N11240 ;    feed = z_feed
N11250 ;else
N11260 feed = feed_rate
N11270 ;endif
N11280 if feed ne prevFeed
N11290 change(feed) = true
N11300 else
N11310 change(feed) = false
N11320 endif
N11330 else
N11340 iFeedType = 94
N11350 if change(iFeedType)
N11360 change(feed) = true
N11370 endif
N11380 endif
N11390 ; ---- 4x
N11400 if bFeedoutput
N11410 change(feed) = true
N11420 bFeedoutput  = false
N11430 endif
N11440 iMotionmode = 1
N11450 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],['G'iDiametercomp' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' ']}
N11460 {['G'iFeedType' '],['D'iDiameteroffset' '],['X'xpos ' '],['Y'ypos ' '],['Z'zpos ' '],[cR1,nR1pos ' '],['F'feed ' ']}
N11470 if change(iMotionmode)
N11480 change(iMotionmode)     = false
N11490 endif
N11500 if change(iMplane)
N11510 change(iMplane)         = false
N11520 endif
N11530 if change(iDiametercomp)
N11540 change(iDiametercomp)   = false
N11550 endif
N11560 if change(iWorkoffset)
N11570 change(iWorkoffset)     = false
N11580 endif
N11590 if change(iAbsincmode)
N11600 change(iAbsincmode)     = false
N11610 endif
N11620 if change(iDiameteroffset)
N11630 change(iDiameteroffset) = false
N11640 endif
N11650 if change(iFeedType)
N11660 change(iFeedType) = false
N11670 endif
N11680 prevFeed = feed
N11690 change(nRapidfeed)          = true
N11700 endp

N11710 ; -----------
N11720 @arc
N11730 ; SolidCAM call to normal arc movement
N11740 ; We do not use this procedure to output code
N11750 ; We create our own procedure for this so that we have one arc formatting section
N11760 call @usr_arc
N11770 endp

N11780 @arc_yz
N11790 ; SolidCAM call to YZ arc movement
N11800 ; We not use this procedure to output code
N11810 ; We create our own procedure for this so that we have one arc formatting section
N11820 call @usr_arc
N11830 endp

N11840 @arc_zx
N11850 ; SolidCAM call to ZX arc movement
N11860 ; We not use this procedure to output code
N11870 ; We create our own procedure for this so that we have one arc formatting section
N11880 call @usr_arc
N11890 endp

N11900 @usr_arc
N11910 ; Handle output for arc movement (G02/G03)
N11920 if bFeedoutput
N11930 change(feed) = true
N11940 bFeedoutput  = false
N11950 endif
N11960 if arc_direction eq CCW then
N11970 iMotionmode = 3
N11980 else
N11990 iMotionmode = 2
N12000 endif
N12010 if arc_plane eq XY
N12020 iMplane = 17
N12030 endif
N12040 if arc_plane eq ZX
N12050 iMplane = 18
N12060 endif
N12070 if arc_plane eq YZ
N12080 iMplane = 19
N12090 endif
N12100 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],['G'iDiametercomp' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' ']}
N12110 {['D'iDiameteroffset' '],['X'xpos ' '],['Y'ypos ' '],['Z'zpos ' ']}
N12120 if arc_plane eq XY then
N12130 if iArcmode eq 1 or (arc_size eq 360 and iArcmode eq 3)
N12140 {'I'xcenter ' ', 'J'ycenter ' '}
N12150 endif
N12160 if iArcmode eq 2 or (arc_size eq 360 and iArcmode eq 4)
N12170 {'I'xcenter_rel ' ', 'J'ycenter_rel ' '}
N12180 endif
N12190 if (iArcmode eq 3 or iArcmode eq 4) and arc_size ne 360
N12200 if arc_size >= 180 then
N12210 radius = -radius
N12220 endif
N12230 {'R'radius' '}
N12240 endif
N12250 endif
N12260 if arc_plane eq ZX then
N12270 if iArcmode eq 1 or (arc_size eq 360 and iArcmode eq 3)
N12280 {'I'xcenter ' ', 'K'zcenter ' '}
N12290 endif
N12300 if iArcmode eq 2 or (arc_size eq 360 and iArcmode eq 4)
N12310 {'I'xcenter_rel ' ', 'K'zcenter_rel ' '}
N12320 endif
N12330 if (iArcmode eq 3 or iArcmode eq 4) and arc_size ne 360
N12340 if arc_size >= 180 then
N12350 radius = -radius
N12360 endif
N12370 {'R'radius' '}
N12380 endif
N12390 endif
N12400 if arc_plane eq YZ then
N12410 if iArcmode eq 1 or (arc_size eq 360 and iArcmode eq 3)
N12420 {'J'ycenter ' ', 'K'zcenter ' '}
N12430 endif
N12440 if iArcmode eq 2 or (arc_size eq 360 and iArcmode eq 4)
N12450 {'J'ycenter_rel ' ', 'K'zcenter_rel ' '}
N12460 endif
N12470 if (iArcmode eq 3 or iArcmode eq 4) and arc_size ne 360
N12480 if arc_size >= 180 then
N12490 radius = -radius
N12500 endif
N12510 {'R'radius' '}
N12520 endif
N12530 endif
N12540 {['F'feed ' ']}
N12550 if change(iMotionmode)
N12560 change(iMotionmode)     = false
N12570 endif
N12580 if change(iMplane)
N12590 change(iMplane)         = false
N12600 endif
N12610 if change(iDiametercomp)
N12620 change(iDiametercomp)   = false
N12630 endif
N12640 if change(iWorkoffset)
N12650 change(iWorkoffset)     = false
N12660 endif
N12670 if change(iAbsincmode)
N12680 change(iAbsincmode)     = false
N12690 endif
N12700 if change(iDiameteroffset)
N12710 change(iDiameteroffset) = false
N12720 endif
N12730 change(nRapidfeed)          = true
N12740 endp

N12750 ;-------------------

N12760 @compensation
N12770 ; SolidCAM call for diameter compensation
N12780 ; We not use this procedure to output code
N12790 ; We create our own procedure for this so that we..
N12800 ;   have can control placement during @line,@arc
N12810 if side eq COMP_LEFT then
N12820 iDiametercomp = 41
N12830 change(iDiameteroffset) = true
N12840 endif
N12850 if side eq COMP_RIGHT then
N12860 iDiametercomp = 42
N12870 change(iDiameteroffset) = true
N12880 endif
N12890 if side eq COMP_OFF then
N12900 iDiametercomp = 40
N12910 change(iDiameteroffset) = false
N12920 endif
N12930 endp

N12940 @usr_compensation_output
N12950 ; Handle line for diameter compensation output (Radial)
N12960 if change(iDiametercomp)
N12970 if iDiametercomp eq 40
N12980 {'G'iDiametercomp' '}
N12990 else
N13000 {'G'iDiametercomp, ' D'tool_number' '}
N13010 endif
N13020 endif
N13030 endp

N13040 ;-------------------

N13050 @usr_optionalstop
N13060 ; Handle line for Optional Stop gmcode
N13070 iStopmode = 1
N13080 {nb, 'M'iStopmode:mcode_f' '}
N13090 endp

N13100 @usr_forcedstop
N13110 ; Handle line for forced Stop gmcode
N13120 iStopmode = 0
N13130 {nb, 'M'iStopmode:mcode_f' '}
N13140 endp

N13150 @usr_StopM00_sametool
N13160 ; Handle output for forced stopM00 between operations using the same tool
N13170 if bCoolExist
N13180 iCoolantM1 = iCoolantM1OFF
N13190 iCoolantM2 = iCoolantM2OFF
N13200 iCoolantM3 = iCoolantM3OFF
N13210 iCoolantM4 = iCoolantM4OFF
N13220 iCoolantM5 = iCoolantM5OFF
N13230 iCoolantM6 = iCoolantM6OFF
N13240 iCoolantM7 = iCoolantM7OFF
N13250 iCoolantM8 = iCoolantM8OFF
N13260 call @usr_coolant_output
N13270 endif
N13280 iSpindleDir = 5
N13290 {nb}
N13300 call @usr_spindle_mcode_output
N13310 if sHomestrstpsame ne ''
N13320 sHomestr = sHomestrstpsame
N13330 call @usr_prep_home_axis
N13340 endif
N13350 call @usr_forcedstop
N13360 sUsrmsg = sStopMessage
N13370 call @usr_message
N13380 {nb}
N13390 call @usr_abs_inc_output
N13400 call @m_feed_spin
N13410 call @usr_spindle_mcode_output
N13420 change(xpos) = true
N13430 change(ypos) = true
N13440 change(zpos) = false
N13450 call @rapid_move
N13460 call @usr_heightcomp_on
N13470 endp

N13480 @usr_StopM00_difftool
N13490 ; Handle output for forced stopM00 between operations using different tools
N13500 if bCoolExist
N13510 iCoolantM1 = iCoolantM1OFF
N13520 iCoolantM2 = iCoolantM2OFF
N13530 iCoolantM3 = iCoolantM3OFF
N13540 iCoolantM4 = iCoolantM4OFF
N13550 iCoolantM5 = iCoolantM5OFF
N13560 iCoolantM6 = iCoolantM6OFF
N13570 iCoolantM7 = iCoolantM7OFF
N13580 iCoolantM8 = iCoolantM8OFF
N13590 call @usr_coolant_output
N13600 endif
N13610 iSpindleDir = 5
N13620 {nb}
N13630 call @usr_spindle_mcode_output
N13640 if sHomestrstpdiff ne ''
N13650 sHomestr = sHomestrstpdiff
N13660 call @usr_prep_home_axis
N13670 endif
N13680 call @usr_forcedstop
N13690 sUsrmsg = sStopMessage
N13700 call @usr_message
N13710 bStopM00difftool = true
N13720 endp

N13730 ;-------------------

N13740 @change_ref_point
N13750 ; @change_ref_point Not Supported in this template

N13760 endp

N13770 ;-------------------

N13780 @rotate
N13790 ; @rotate Not Supported in this template
N13800 endp

N13810 ;-------------------

N13820 @mirror
N13830 ; @mirror Not Supported in this template
N13840 endp

N13850 ;-------------------

N13860 @fourth_axis
N13870 ; @fourth_axis Not Supported in this template
N13880 endp
N13890 ;-------------------

N13900 @message
N13910 ; We don't use messages directly from SolidCAM
N13920 endp

N13930 @usr_message
N13940 ; Handle output for messages
N13950 ; We don't use messages directly from SolidCAM
N13960 {nb, cCb,sUsrmsg,cCe}
N13970 endp

N13980 ;-------------------

N13990 @drill
N14000 ; Handle output for drill cycles
N14010 local string p_f
N14020 p_f = '5.1(p)'
N14030 {nb,'Z'zpos' '}
N14040 if drill_type eq G81
N14050 iDrillmode = 81
N14060 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' F'feed ' '}
N14070 endif
N14080 if drill_type eq G82
N14090 iDrillmode = 82
N14100 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' P'P_Dwell:p_f' F'feed' '}
N14110 endif
N14120 if drill_type eq G83
N14130 iDrillmode = 83
N14140 if P_Dwell eq 0
N14150 change(P_Dwell) = false
N14160 endif
N14170 if I_FirstPeck eq 0
N14180 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' Q'Q_Peck,[' P'P_Dwell:p_f],' F'feed' '}
N14190 else
N14200 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' I'I_FirstPeck' J'J_ReduceAmount' K'K_MinimumDepth,[' P'P_Dwell:p_f],' F'feed' '}
N14210 endif
N14220 endif
N14230 if drill_type eq G73
N14240 iDrillmode = 73
N14250 if P_Dwell eq 0
N14260 change(P_Dwell) = false
N14270 endif
N14280 if I_FirstPeck eq 0
N14290 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' Q'Q_Peck' K'K_MinimumDepth,[' P'P_Dwell:p_f],' F'feed' '}
N14300 else
N14310 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' I'I_FirstPeck' J'J_ReduceAmount' K'K_MinimumDepth,[' P'P_Dwell:p_f],' F'feed' '}
N14320 endif
N14330 endif
N14340 if drill_type eq G84
N14350 iDrillmode = 84
N14360 if cG84p ne ''
N14370 {nb,cG84p}
N14380 endif
N14390 if bG84spin
N14400 change(spin) = true
N14410 else
N14420 change(spin) = false
N14430 endif
N14440 {nb, cDr,cG84 ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z,[' S'spin:fG84spin],' F'(tool_drill_lead*spin) ' '}
N14450 endif
N14460 if drill_type eq G74  ;!@#$%AC 0.4
N14470 iDrillmode = 74
N14480 {nb}
N14490 iSpindleDir = 4
N14500 bUsrcall = true
N14510 call @usr_spindle_mcode_output
N14520 if cG84p ne ''
N14530 {nb,cG84p}
N14540 endif
N14550 if bG84spin
N14560 change(spin) = true
N14570 else
N14580 change(spin) = false
N14590 endif
N14600 {nb, cDr'G'iDrillmode  ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z,[' S'spin:fG84spin],' F'(tool_drill_lead*spin) ' '}
N14610 endif
N14620 ;if drill_type eq G84_Peck      ;!@#$%AC 0.4 deleted because 12 cycle limit
N14630 ;    iDrillmode = 84
N14640 ;    if cG84p ne ''
N14650 ;       {nb,cG84p}
N14660 ;    endif
N14670 ;    if bG84spin
N14680 ;        change(spin) = true
N14690 ;    else
N14700 ;        change(spin) = false
N14710 ;    endif
N14720 ;    {nb, cDr,cG84 ' Z'drill_lower_z' R'drill_upper_z' 'cCycs,['S'spin:fG84spin' '],'F'(tool_drill_lead*spin) ' '}
N14730 ;endif
N14740 if drill_type eq G85
N14750 if P_Dwell eq 0
N14760 iDrillmode = 85
N14770 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' F'feed ' '}
N14780 else
N14790 iDrillmode = 89
N14800 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' P'P_Dwell:p_f' F'feed' '}
N14810 endif
N14820 endif
N14830 if drill_type eq G86
N14840 iDrillmode = 86
N14850 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' F'feed ' '}
N14860 endif
N14870 if drill_type eq G87  ;!@#$%AC 0.4
N14880 if P_Dwell eq 0
N14890 iDrillmode = 87
N14900 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' Q'Q_Shift' F'feed ' '}
N14910 else
N14920 iDrillmode = 87
N14930 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' P'P_Dwell:p_f' Q'Q_Shift' F'feed' '}
N14940 endif
N14950 endif
N14960 if drill_type eq G76  ;!@#$%AC 0.4
N14970 if P_Dwell eq 0
N14980 iDrillmode = 76
N14990 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' Q'Q_Shift' F'feed ' '}
N15000 else
N15010 iDrillmode = 76
N15020 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' P'P_Dwell:p_f' Q'Q_Shift' F'feed' '}
N15030 endif
N15040 endif
N15050 if drill_type eq G88
N15060 if P_Dwell eq 0
N15070 iDrillmode = 88
N15080 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' F'feed ' '}
N15090 else
N15100 iDrillmode = 88
N15110 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' P'P_Dwell:p_f' F'feed' '}
N15120 endif
N15130 endif
N15140 if drill_type eq G89
N15150 if P_Dwell eq 0
N15160 iDrillmode = 89
N15170 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' F'feed ' '}
N15180 else
N15190 iDrillmode = 89
N15200 {nb, cDr'G'iDrillmode ' X'xpos' Y'ypos' Z'drill_lower_z' R'drill_upper_z' P'P_Dwell:p_f' F'feed' '}
N15210 endif
N15220 endif
N15230 endp

N15240 ;-------------------

N15250 @drill_point
N15260 ; Handle output for drill positions
N15270 ;local integer i                                                                     ;!@#$%AC 0.4 deleted because 12 cycle limit
N15280 ;if drill_type eq G84_Peck
N15290 ;    iNumpecks = (drill_depth/Q_Peck)+1.
N15300 ;	nCorrectedpeck = drill_depth/iNumpecks
N15310 ;    i = 1
N15320 ;    while i <= iNumpecks
N15330 ;		{nb,'X'xpos ' ', 'Y'ypos ' ', 'Z'(drill_upper_z-(nCorrectedpeck*i))' '}
N15340 ;	    i = i + 1
N15350 ;	endw
N15360 ;else
N15370 if !first_drill then                                               ;!@#$%AC 0.5 uncommented from 0.4
N15380 {nb,['X'xpos ' '], ['Y'ypos ' '], ['Z'zpos ' ']}
N15390 endif
N15400 ;endif
N15410 endp


N15420 ;-------------------

N15430 @end_drill
N15440 ; Handle output to cancel drill cycles
N15450 iDrillmode = 80
N15460 if change(iDrillmode)
N15470 {nb, 'G'iDrillmode' '}
N15480 endif
N15490 iMotionmode = 9999
N15500 endp

N15510 ;-------------------

N15520 @m_feed_spin
N15530 ; Handle output for spindle change
N15540 if tool_direction eq CW then
N15550 iSpindleDir = 3
N15560 else
N15570 iSpindleDir = 4
N15580 endif
N15590 if change(spin)
N15600 call @usr_spindle_output
N15610 endif
N15620 endp

N15630 @start_tool
N15640 ; Handle setting and output for spindle start
N15650 if tool_direction eq CW then
N15660 iSpindleDir = 3
N15670 else
N15680 iSpindleDir = 4
N15690 endif
N15700 call @usr_spindle_output
N15710 call @usr_spindle_mcode_output
N15720 endp

N15730 @usr_spindle_output
N15740 ; Handle output for spindle
N15750 {nb,'S'spin:integer_def_f ' '}
N15760 endp

N15770 @usr_spindle_mcode_output
N15780 ; Handle output for spindle
N15790 {'M'iSpindleDir:mcode_f ' '}
N15800 endp

N15810 ;-------------------

N15820 @offset_change
N15830 ; Handle setting of Diameter offset
N15840 iDiameteroffset = d_offset
N15850 change(iDiameteroffset) = false
N15860 endp

N15870 ;-------------------

N15880 @job_plane
N15890 ; @job_plane Not Supported in this template
N15900 endp

N15910 ;-------------------

N15920 @call_proc
N15930 ; Handle call to subroutine
N15940 call @home_number
N15950 if bTlchg
N15960 call @usr_ct
N15970 bTlchg = false
N15980 else
N15990 call @usr_r1pos_calc
N16000 if rot_axis_type ne axis4_none
N16010 Xpos = 0
N16020 Xnext = 0
N16030 nTcXnext = 0
N16040 else
N16050 xpos = xnext
N16060 endif
N16070 ypos = ynext
N16080 zpos = tool_start_plane
N16090 if change(nR1pos)
N16100 if sHomestrrot ne ''
N16110 sHomestr = sHomestrrot
N16120 call @usr_prep_home_axis
N16130 endif
N16140 iMotionmode = 0
N16150 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],['G'iAbsincmode ' '],[cWo,iWorkoffset' '],['X'xpos ' '],['Y'ypos ' '],[cR1,nR1pos ' ']}
N16160 call @usr_heightcomp_on
N16170 ;			bSkipxyrapid = true
N16180 else
N16190 iMotionmode = 0
N16200 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],['G'iAbsincmode ' '],[cWo,iWorkoffset' '],['X'xpos ' '],['Y'ypos ' ']}
N16210 endif
N16220 endif
N16230 {nb, 'M98 P'label}
N16240 {[' ('message, ')']}
N16250 endp

N16260 ;-------------------

N16270 @proc
N16280 ; Handle beggining of subroutine
N16290 {nl, 'O'label}
N16300 endp

N16310 ;-------------------

N16320 @end_proc
N16330 ; Handle end of subroutine
N16340 {nb, 'M99'}
N16350 endp

N16360 ;----------------

N16370 @loop_matrix_info
N16380 bSkipxyrapid = false
N16390 endp
N16400 @loop
N16410 ; Loops Not Supported in this template
N16420 if bTraceUsrcall
N16430 if bUsrcall
N16440 {nl,'>>>>UserCalled @loop<<<<<    '}
N16450 bUsrcall = false
N16460 endif
N16470 endif
N16480 endp

N16490 ;----------------

N16500 @end_loop
N16510 ; Loops Not Supported in this template
N16520 if bTraceUsrcall
N16530 if bUsrcall
N16540 {nl,'>>>>UserCalled @end_loop<<<<<    '}
N16550 bUsrcall = false
N16560 endif
N16570 endif
N16580 endp

N16590 ;-------------------

N16600 @usr_prep_home_axis
N16610 ; Handle parsing of homing string and preping of output for homing
N16620 local integer i line l mode p1
N16630 local string s s1 l1 pstr
N16640 s = sHomestr                               ;Original String
N16650 s1 = s                                     ;Temp String
N16660 l = strlen(s1)                             ;Get string length of Temp String
N16670 ;*Pull out Homing mode
N16680 i = 1
N16690 while i < 50
N16700 i = i + 1
N16710 p1 = instr(s1,':')                         ;Find the position of first ":"
N16720 l1 = left(s1,p1-1)                         ;Pull out the left of first ":"
N16730 mode = tonum(l1)                           ;Convert string into Integer for "Mode" variable
N16740 s1 = substr(s1,p1+1,l)                     ;Remove Homing mode from Temp String
N16750 l = strlen(s1)                             ;Get string length of Temp String
N16760 ;*Pull out Preperation String
N16770 p1 = instr(s1,':')                         ;Find the position of second ":"
N16780 if p1 ne 0                                 ;Check if PrepStr is defined
N16790 pstr = left(s1,p1-1)                   ;Pull out the left of second ":"
N16800 s1 = substr(s1,p1+1,l)                 ;Remove PrepString from Temp String
N16810 l = strlen(s1)                         ;Get string length of Temp String
N16820 endif
N16830 ;*Pull out homing lines and send to output procedure
N16840 p1 = instr(s1,';')                      ;Find the position of ";"
N16850 if p1 ne 0
N16860 line = line + 1                     ;Keep track of lines. Not Used!!
N16870 l1 = left(s1,p1-1)                  ;Pull out the left of ";"
N16880 iHomingmode = mode                  ;Send Homing Mode
N16890 cHomep = pstr                       ;Send Preperation String
N16900 sHomeline = l1                      ;Send Homing Line
N16910 call @usr_home_axis
N16920 else
N16930 line = line + 1                     ;Keep track of lines. Not Used!!
N16940 iHomingmode = mode                  ;Send Homing Mode
N16950 cHomep = pstr                       ;Send Preperation String
N16960 sHomeline = s1                      ;Send Homing Line
N16970 call @usr_home_axis
N16980 i = 50                              ;Force end of While-Loop
N16990 endif
N17000 if i ne 50
N17010 s1 = substr(s1,p1+1,l)              ;Remove Homing mode from Temp String
N17020 l = strlen(s1)                      ;Get string length of Temp String
N17030 endif
N17040 endw
N17050 endp

N17060 @usr_home_axis
N17070 ; Handle output for homing the X-axis
N17080 local integer sav_iWorkOffset
N17090 sav_iWorkOffset = iWorkOffset
N17100 if iHomingmode eq 1
N17110 {nb,'G28 'sHomeline}
N17120 endif
N17130 if iHomingmode eq 2
N17140 {nb}
N17150 iAbsincmode = 91
N17160 change(iAbsincmode) = true
N17170 {cHomep}
N17180 call @usr_abs_inc_output
N17190 {'G28 '}
N17200 { sHomeline}
N17210 iAbsincmode = 90
N17220 change(iAbsincmode) = true
N17230 endif
N17240 if iHomingmode eq 3 or iHomingmode eq 4
N17250 if iWorkOffsetmode eq 1 or iWorkOffsetmode eq 3
N17260 iWorkOffset = 53
N17270 {nb,cHomep,['G'iWorkoffset' ']}
N17280 endif
N17290 if iWorkOffsetmode eq 2
N17300 iWorkOffset = 0
N17310 {nb,cHomep,[cWo,iWorkoffset' ']}
N17320 endif
N17330 call @usr_abs_inc_output
N17340 { sHomeline}
N17350 iWorkOffset = sav_iWorkOffset
N17360 if iHomingmode eq 3
N17370 change(iWorkOffset) = false
N17380 endif
N17390 endif
N17400 if iHomingmode eq 5
N17410 {nb,cHomep'G30 'sHomeline}
N17420 endif
N17430 if iHomingmode eq 6
N17440 {nb}
N17450 {cHomep}
N17460 iAbsincmode = 91
N17470 change(iAbsincmode) = true
N17480 call @usr_abs_inc_output
N17490 {'G30 '}
N17500 { sHomeline}
N17510 iAbsincmode = 90
N17520 change(iAbsincmode) = true
N17530 endif
N17540 if iHomingmode eq 7
N17550 {nb,cHomep'G90 G54 'sHomeline}
N17560 endif
N17570 endp

N17580 ;-------------------

N17590 @usr_campart_path
N17600 ; Handle output for spindle
N17610 iSlength_g_file_name = strlen( g_file_name)
N17620 iSlength_full_g_file_name = strlen(full_g_file_name)
N17630 iSlengthcampartpath = iSlength_full_g_file_name - iSlength_g_file_name
N17640 sCamfilepath = left(full_g_file_name,iSlengthcampartpath)
N17650 endp

N17660 ;-------------------

N17670 @Multiple_Fixtures
N17680 ; Handle multiple fixture support
N17690 local integer i
N17700 ;----From tools 2 and up
N17710 ;----Closes the sSubspath(tempfile) for the previous tool change
N17720 ;----Runs loop to print G5x and copy in the tempfile
N17730 ;----Sets the tempfile to new name for next tool
N17740 if bFrombeginchangetool eq True
N17750 if !first_tool
N17760 {nl,'!!close file=' sSubspath '!!'}
N17770 i = 1
N17780 while i <= iNumber_of_Fixtures
N17790 {nl,cCb'-----LOOPING CODE-----'cCe}
N17800 if i ne 1
N17810 {nb,cWo,((iWorkoffset-1)+i)}
N17820 endif
N17830 {nl,'!!copy file=' sSubspath '!!'}
N17840 i = i + 1
N17850 endw
N17860 sSubspath = sCamfilepath + 'TEMPFILE' + tostr(iTcnumber:'5.0(n)')
N17870 endif
N17880 bFrombeginchangetool = False
N17890 endif

N17900 ;----At end of tool_change
N17910 ;----Opens tempfile to print out gcode
N17920 if bFromendchangetool eq True
N17930 sSubspath = sCamfilepath + 'TEMPFILE' + tostr(iTcnumber:'5.0(n)')
N17940 {nl,'!!open file=' sSubspath '!!'}
N17950 bFromendchangetool = False
N17960 endif

N17970 ;----At end_program
N17980 ;----Closes the sSubspath(tempfile) for the current tool change
N17990 ;----Runs loop to print G5x and copy in the tempfile
N18000 if bFromendprogram eq True
N18010 {nl,'!!close file=' sSubspath '!!'}
N18020 i = 1
N18030 while i <= iNumber_of_Fixtures
N18040 {nl,cCb'-----LOOPING LAST TOOL CHANGE CODE-----'cCe}
N18050 if i ne 1
N18060 {nb,cWo,((iWorkoffset-1)+i)}
N18070 endif
N18080 {nl,'!!copy file=' sSubspath '!!'}
N18090 i = i + 1
N18100 endw
N18110 bFromendprogram = False
N18120 endif

N18130 ;----At eng_of_file
N18140 ;----Delete all tempfiles
N18150 if bFromendoffile eq True
N18160 i = 1
N18170 while i <= iTcnumber
N18180 sSubspath = sCamfilepath + 'TEMPFILE' + tostr(i:'5.0(n)')
N18190 {nl,'!!delete file=' sSubspath '!!'}
N18200 i = i + 1
N18210 endw
N18220 bFromendoffile = false
N18230 endif

N18240 endp

N18250 ;-------------------

N18260 @usr_r1pos_calc
N18270 ; Calculate Rotary 1 Position (Main Spindle)
N18280 ; tmatrix + 4th Transform + cpos + 5xapos
N18290 ; Note: Angular Feed Formula fc = f*(180/(pi*r))
N18300 ; Note: fc=deg/min, f=linear feed
N18310 nR1postmatrix = -angle_4x_around_y * iR1dir                        ;Rotary from CoordSys (tmatrix)
N18320 nR1postransform = (-angle) * iR1dir                               ;Rotary from 4x-Transform
N18330 nR1poscpos = (-cpos) * iR1dir                                     ;Rotary from C-axis cutting
N18340 nR1pos5x = (-bpos) * iR1dir                                       ;Rotary from 4/5x Simulatenous
N18350 nR1pos = nR1postmatrix + nR1postransform + nR1poscpos + nR1pos5x
N18360 ;{nb,'Updated Position =' cpos}
N18370 ;{nb,'Updated Position =' nR1pos}
N18380 if bLimit_3axis
N18390 change(nR1pos) = false
N18400 endif
N18410 if nPR1pos ne nR1pos
N18420 change(nR1pos) = TRUE
N18430 ;    else
N18440 ;        change(nR1pos) = FALSE
N18450 endif
N18460 nPR1pos = nR1pos
N18470 endp

N18480 @usr_4x_index
N18490 ; Handle 4x indexing (Rotary moves between operations)
N18500 ;4x-Indexing control (0=Simple Rotation, 1=New WorkOffset, 2=Trig Macro)
N18510 ;4x-Index Clearance control (0=Z-Homing, 1=Z-Tool_Z_Level, 2=Z-Tool_start_plane)

N18520 call @usr_r1pos_calc
N18530 if change(nR1pos)
N18540 if i4xIndexMode eq 0 ;Simple Rotation
N18550 if i4xIndexClearanceMode eq 0
N18560 if sHomestrrot ne ''
N18570 sHomestr = sHomestrrot
N18580 call @usr_prep_home_axis
N18590 endif
N18600 iMotionmode = 0
N18610 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],[cR1,nR1pos ' ']}
N18620 endif
N18630 if i4xIndexClearanceMode eq 1
N18640 if tool_z_level < tool_start_plane
N18650 Print 'WARNING!! Tool Z Level is below Tool Start Plane in CoordSys'
N18660 {nl,'WARNING!! Tool Z Level is below Tool Start Plane in CoordSys'}
N18670 endif
N18680 iMotionmode = 0
N18690 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],'Z'nPtool_z_level ' '}
N18700 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],[cR1,nR1pos ' ']}
N18710 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],'Z'tool_z_level ' '}
N18720 endif
N18730 if i4xIndexClearanceMode eq 2
N18740 iMotionmode = 0
N18750 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],'Z'nPtool_start_plane ' '}
N18760 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],[cR1,nR1pos ' ']}
N18770 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],'Z'tool_start_plane ' '}
N18780 endif
N18790 endif
N18800 if i4xIndexMode eq 1 ;New WorkOffset
N18810 if i4xIndexClearanceMode eq 0
N18820 if sHomestrrot ne ''
N18830 sHomestr = sHomestrrot
N18840 call @usr_prep_home_axis
N18850 endif
N18860 iMotionmode = 0
N18870 iWorkoffset = iWorkoffset + (position-1)
N18880 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],[cR1,nR1pos ' ']}
N18890 endif
N18900 if i4xIndexClearanceMode eq 1
N18910 if tool_z_level < tool_start_plane
N18920 Print 'WARNING!! Tool Z Level is below Tool Start Plane in CoordSys'
N18930 {nl,'WARNING!! Tool Z Level is below Tool Start Plane in CoordSys'}
N18940 endif
N18950 iMotionmode = 0
N18960 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],'Z'nPtool_z_level ' '}
N18970 iWorkoffset = iWorkoffset + (position-1)
N18980 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],[cR1,nR1pos ' ']}
N18990 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],'Z'tool_z_level ' '}
N19000 endif
N19010 if i4xIndexClearanceMode eq 2
N19020 iMotionmode = 0
N19030 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],'Z'nPtool_start_plane ' '}
N19040 iWorkoffset = iWorkoffset + (position-1)
N19050 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],[cR1,nR1pos ' ']}
N19060 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],'Z'tool_start_plane ' '}
N19070 endif
N19080 endif
N19090 endif
N19100 if i4xIndexMode eq 2 ;Trig Macro
N19110 if sHomestrrot ne ''
N19120 sHomestr = sHomestrrot
N19130 call @usr_prep_home_axis
N19140 endif
N19150 call @usr_trig_macro_call
N19160 iMotionmode = 0
N19170 iWorkoffset = 112
N19180 {nb,['G'iMotionmode:mcode_f ' '],['G'iMplane' '],[cWo,iWorkoffset' '],['G'iAbsincmode ' '],[cR1,nR1pos ' ']}
N19190 endif
N19200 endp

N19210 @move_4x ; !@#$%
N19220 ; Handle GPP direct call to Rapid Move (G00)
N19230 ; We not use this procedure to output code
N19240 ; We create our own procedure for this so that we may...
N19250 ;   Sync with @rapid_move, @move_5x, @move_4x, @move4x_polar, @move4x_cartesian
N19260 if change(xpos)
N19270 xpos = 0
N19280 endif
N19290 call @usr_rapid
N19300 endp

N19310 @line_4x ; !@#$%
N19320 ; Handle GPP direct call to Line Movement (G01)
N19330 ; We not use this procedure to output code
N19340 ; We create our own procedure for this so that we may...
N19350 ;   Sync with @line, @line_5x, @line_4x, @line4x_polar, @line4x_cartesian
N19360 call @usr_line
N19370 endp
N19380 @chng_tool_cnext
N19390 endp
N19400 @rotary_info
N19410 endp
N19420 @tmatrix
N19430 endp
N19440 @move_5x ; !@#$%
N19450 ; Handle GPP direct call to Rapid Move (G00)
N19460 ; We not use this procedure to output code
N19470 ; We create our own procedure for this so that we may...
N19480 ;   Sync with @rapid_move, @move_5x, @move_4x, @move4x_polar, @move4x_cartesian
N19490 call @usr_rapid
N19500 endp
N19510 @line_5x ; !@#$%
N19520 ; Handle GPP direct call to Line Movement (G01)
N19530 ; We not use this procedure to output code
N19540 ; We create our own procedure for this so that we may...
N19550 ;   Sync with @line, @line_5x, @line_4x, @line4x_polar, @line4x_cartesian
N19560 call @usr_line
N19570 endp
N19580 @tool_path_info
N19590 endp
N19600 @transform_info
N19610 endp
N19620 @usr_trig_macro_call
N19630 ; Handle SubProgram call to Trig_Macro
N19640 {nb, 'G65P777 X'shift_x ' Y'shift_y ' Z'shift_z ' C'home_number:'5.3' ' A'bpos:'5.3'  ' I0 J0 K0 '}
N19650 ;{nl,'G65P777 X'shift_x ' Y'shift_y ' Z'shift_z ' C'home_number '. A'nT1pos:'5.3' ' B'bpos:'5.3'  ' I0 J0 K0'}
N19660 endp
N19670 @usr_trig_macro_output
N19680 ; Handle Trig_Macro output (Subprogram)
N19690 {nl}
N19700 {nl, 'O777'}
N19710 ;Copies Work Offset(i.e. G54) to G112 to use for Calculations
N19720 {nb,'G103 P1'}
N19730 {nb,'#7041= [#[5201 + 20 * #3] + #24]'} ; G112 x
N19740 {nb,'M01'}
N19750 {nb,'#7042= [#[5202 + 20 * #3]+ #25]'} ; G112 y
N19760 {nb,'M01'}
N19770 {nb,'#7043= [#[5203 + 20 * #3] + #26]'} ; G112 z
N19780 {nb,'M01'}
N19790 {nb,'#7044= [#[5204 + 20 * #3]]'} ; G112 A
N19800 {nb,'M01'}
N19810 {nb,'#7045= [#[5205 + 20 * #3]]'} ; G112 B
N19820 {nb,'M01'} ;Stop added For HS-1RP to not read ahead
N19830 ;Variables 7xxx are G1xx additional work offsets. Puts work offsets in a variable
N19840 ;#7001 through #7005 = G110 X, Y, Z, A, B   (this will be the A axis Zero) X=#7001 Z=#7003
N19850 ;#7021 through #7025 = G111 X, Y, Z, A, B   (this will be the B axis Zero) X=#7021 Z=#7022
N19860 ;x1 = #7021
N19870 ;y  = #7022
N19880 ;Y2 = #7002  PICKED UP CENTER OF Y-AXIS  G110#
N19890 ;z  = #7003  PICKED UP CENTER OF Z-AXIS  G110#
N19900 ;Delta Changes In Y & Z- Leg of triangle used to calculate new Y & Z
N19910 {nb,'#141= [#7042 - #7002]'} ; delta y
N19920 {nb,'M01'}
N19930 {nb,'#142= [#7043 - #7003]'} ; delta z
N19940 {nb,'M01'}
N19950 ;Trig. Formula on how to calculate offcenter parts when they rotate around the 4th axis
N19960 ;z = z*cos(dev_angle) - y*sin(dev_angle)
N19970 ;y = z*sin(dev_angle)  + y*cos(dev_angle)
N19980 ;Actual Trig. Formula to Calulate the change in Z & Y in the machine
N19990 {nb,'#148 = [[#142*COS[-#1]] - [#141*SIN[-#1]]](NEW Y B)'}  ; z
N20000 {nb,'M01'}
N20010 {nb,'#149 = [[#142*SIN[-#1]] + [#141*COS[-#1]]](NEW Z B)'}  ; y
N20020 {nb,'M01'}
N20030 {nb}
N20040 ;New Calculated Home Position- Uses shifts from SolidCAM, Centers of machine, and calculated change in Z & Y
N20050 {nb,'#7041 = #7041 + #4'} ; X + user shift  = new X in g112
N20060 {nb,'M01'}
N20070 {nb,'#7042 = #7002 + #149 + #5'} ; center Y2 + new Y calculated point + user shift  = new Y in g112
N20080 {nb,'M01'}
N20090 {nb,'#7043 = #7003 + #148 + #6'} ; center z  + new z calculated point + user shift  = new z in g112
N20100 {nb,'M01'}
N20110 {nb,'G103'}
N20120 ;{nb,'G112'}
N20130 ;{nb,' G0 A#1'}
N20140 ;Used to end subprogram
N20150 {nb,'M99'}
N20160 {nl}
N20170 endp
N20180 @home_data
N20190 local integer var2
N20200 local string  var1
N20210 if position ne 1
N20220 {nl,'(+++++++++++++++++)' }
N20230 call @home_number
N20240 {nl, '(' cWo,iWorkoffset') '}
N20250 if change(iWorkoffset); !@#$% Force !change for variable
N20260 change(iWorkoffset) = false
N20270 endif
N20280 call @usr_r1pos_calc
N20290 skipline = false
N20300 {'(B' nr1pos ') '}
N20310 if part_home_number <= 6
N20320 var1 = 'G0G90G10L2P'
N20330 var2 = part_home_number
N20340 else
N20350 var1 = 'G0G90G10L20P'
N20360 var2 = part_home_number - 6
N20370 endif
N20380 {nl,var1,var2'X',shift_x_after_rot:'5.3',' ' }
N20390 {nl,var1,var2'Y',shift_y_after_rot:'5.3',' ' }
N20400 {nl,var1,var2'Z',shift_z_after_rot:'5.3',' ' }
N20410 {nl,var1,var2'B0. '}
N20420 {nl}
N20430 else
N20440 {nl,'(+++++++++++++++++)' }
N20450 {nl,'(SET WORK PAGE TO 0.0) ' }
N20460 {nl,'#5201=0.0' }
N20470 {nl,'#5203=0.0' }
N20480 {nl,'#5202=0.0' }
N20490 {nl,'(+++++++++++++++++)' }
N20500 endif
N20510 nr1pos = 9999
N20520 endp

N20530 M5
N20540 M9
N20550 G28 Z0
N20560 G28 X0 Y0
N20570 M30
