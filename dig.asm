PUBLIC DIG
_DIG_ASM SEGMENT CODE
RSEG _DIG_ASM
DIG:                               键盘控制数码管函数
//_____________________________________________________________________________
MOV P2,#0F0H
MOV A,P2
ANL A,#0F0H
CJNE A,#0F0H,KK1
AJMP DIG
KK1:LCALL DELAY
MOV P2,#0F0H
MOV A,P2
ANL A,#0F0H
CJNE A,#0F0H,KKE
AJMP DIG
KKE:MOV R3,A
KEY2:MOV P2,#0FH
MOV A,P2
ANL A,#0FH
CJNE A,#0FH,KK2
AJMP DIG
KK2:LCALL DELAY
MOV P2,#0FH
MOV A,P2
ANL A,#0FH
CJNE A,#0FH,KKE2
AJMP DIG
KKE2:ORL A,R3
MOV B,A
MOV R1,#16
MOV A,#0
MOV DPTR,#KEYT
GO5:PUSH ACC
MOVC A,@A+DPTR
CJNE A,B,GO6
MOV B,A
POP ACC
MOV  P0, A
AJMP OUT1
GO6:POP ACC
INC A
DJNZ R1,GO5
OUT1:
MOV R5,A
LCALL DELAY
AJMP FIRSTDU	
DELAY:
DEL:MOV R6,#200
DEL1:MOV R7,#200
DEL2:DJNZ R7,DEL2
     DJNZ R6,DEL1
	 ret
OUT2:RET
KEYT: DB 77H,7BH,7DH,7EH,0B7H,0BBH,0BDH,0BEH,0D7H,0DBH,0DDH,0DEH,0E7H,0EBH,0EDH,0EEH
//____________________________________________________________________________
双实线之间的代码仍然是利用反极法实现键盘
FIRSTDU:                                ；数码管点亮函数
SETB P0.0
SETB P0.1
SETB P0.2
SETB P0.3                               ；四个数码管均被点亮
DUPRE:
CLR P0.5                                ；将P0.5置0，P0.5与74HC595的12脚相连，12脚是74HC595的输出存储器锁存时钟线
SETB P0.6                               ；将P0.6置1，P0.6与74HC595的13脚相连，13脚是74HC595的输出使能端，当12脚为高电平，13脚为低电平时，输出为高阻状态
MOV  DPTR, #TABLE3                     ；取表头地址
MOV A,R5                               ；将键号赋给A
MOV R4,#0                              ；用于串并转换计次
MOVC  A,@A+DPTR                       ；取TABLE3表中第（A+1）个键的值，即要显示的数字对应的编码
MOV R5,A                               ；将A中的值暂存在B中
DU1:                                   ；数码管编码装入函数
LCALL DELAY                            ；调用外部延时函数
CLR P0.4                               ；将P0.4清0，P0.4与74HC595的11脚相连，11脚是74HC595的数据输入时钟线
INC R4                                ；计次寄存器数值加1
MOV R5,A                              ；将编码暂存在R5中
RRC A                                 ；对A进行带进位的右移，将寄存器A中的数据的最低位，移入C进位标识位中
MOV P0.7,C                            ；将C中的数据送入P0.7端口。P0.7与74HC595的14脚相连，14脚是74HC595的数据线，储存在存储器中
ACALL DELAY                           ；调用延时函数
SETB P0.4                             ；将P0.4的值设置为1产生由0-1的上升沿
CJNE R4,#08H,DU1                      ；判断是否将8位编码均输入进芯片
AJMP DUO                              ；如果全部数据已经输入完成则转入输出函数
DUO:                                  ；数码管的点亮
SETB P0.5                             ；将P0.5置1。在15脚即存储器锁存时钟线
产生一个脉冲的上升沿，使得芯片输出存储器锁存移位寄存器中的状态值
CLR P0.6                                 ；将P0.6置0
LCALL DELAY                           ；调用延时函数，使数码管点亮延时一段时间
LJMP DIG                              ；跳转到句首，使功能能够被多次实现
RET
TABLE3:DB	11111100B	
       	DB	00001100B	
	DB	11011010B	
	DB	11110010B		
	DB	01100110B		
    DB	10110110B	
	DB	10111110B	
   	DB	11100000B	
	DB	11111110B	
	DB	11110110B	
	DB	11101110B	
	DB	00111110B	
	DB	10011100B	
	DB	01111010B	
	DB	10011110B	
	DB	10001110B	 
	
END
