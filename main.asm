 $INCLUDE(key2.inc)
  $INCLUDE(flo2.inc)
  $INCLUDE(delay.inc)                 ；调用外部的延时函数声明
  $INCLUDE(dig.inc)                   ；调用外部的数码管函数的声明
  $INCLUDE(digi.inc)
    ORG    0000H
    LJMP   MAIN
    ORG    0003H
    LJMP   IN0           
    ORG 0013H
    LJMP FLO21
    ORG 000BH
    LJMP TIME0
    ORG 0030H                        ；设置主函数和中断的入口地址

MAIN:
   MOV SP,#30H                     ；设置堆栈
   MOV TMOD,#01H
   MOV TH0,#0FEH
   MOV TL0,#0CH                    ；设置计数器的初值
   CLR IT0
   CLR IT1                           ；将两个中断的处罚方式设置位电平触发
   SETB EA                          ；打开中断总开关
   SETB EX0
   SETB EX1                         ；打开中断子开关
   SETB PX0                         ；设置外部中断0为高优先级
   SETB ET0                         ；允许定时器0溢出中断
   RUNE:    
   NOP
   LCALL KEY2                       ；调用键盘控制数码管和LED灯程序
   AJMP RUNE   
                                                                    
IN0:                                ；中断0，跳转到ERR函数
   NOP
   LJMP SECDUE0
RETI


FLO21:
  NOP
  MOV R6,#0FEH                                ；设置流水灯起点并输入编码
  MOV R7,#50H                                 ；设置流水灯流水10次
  MOV A,R6
  SETB TR0                                    ；打开计时器
RETI

SECDUE0:
MOV P0,#00H
MOV R0,#3                          ；设置闪烁次数为3
SECDUE:
MOV R2,#0FFH                       ；设置一次闪烁实际上为循环0FFH次
SECDUE1:
SETB P0.0
CLR P0.1
CLR P0.2
CLR P0.3                           ；设置初值点亮1个数码管，下同
MOV R5,#9EH
MOV R4,#0
LCALL DIGI                         ；切换数码管显示函数，下同
SECDUE2:
CLR P0.0
SETB P0.1
CLR P0.2
CLR P0.3
MOV R5,#0EEH
MOV R4,#0
LCALL DIGI
SECDUE3:
CLR P0.0
CLR P0.1
SETB P0.2
CLR P0.3
MOV R5,#0EEH
MOV R4,#0
LCALL DIGI
SECDUE4:
CLR P0.0
CLR P0.1
CLR P0.2
SETB P0.3
MOV R5,#02H
MOV R4,#0
LCALL DIGI
DJNZ R2,SECDUE1
AJMP DUOUT
DUOUT:
LCALL DELAY                                   ；多次调用延时以加长时间
LCALL DELAY
LCALL DELAY
DJNZ R0,SECDUE
LJMP DUEND
DUEND:
RETI




END
