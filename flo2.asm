PUBLIC FLO2
_FLO2_ASM SEGMENT CODE
RSEG _FLO2_ASM

TIME0:                           
MOV P0,A                                    ；点亮LED
LCALL DELAY
MOV A,R7
CJNE A,#00H,TIME01                            ；判断是否到达十次
CLR TR0
MOV P0,#0FFH                                ；关灯
RETI
TIME01:
MOV A,R6
RL A                                           ；实现流水
DEC R7
MOV R6,A
AJMP TIME0


END
