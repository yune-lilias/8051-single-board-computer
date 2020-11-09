$INCLUDE(dig.inc)                  ；调用外部的数码管函数的声明 
$INCLUDE(delay.inc)                 ；调用外部的延时函数声明
PUBLIC KEY2
_KEY2_ASM SEGMENT CODE
RSEG _KEY2_ASM
KEY2:                              ；利用反极法实现键盘的控制功能
MOV P2,#0F0H                 ；将键盘的行线P2.0,P2.1,P2.2,P2.3置0，列线P2.4,P2.5,P2.6,P2.7置1
MOV A,P2                     ；保存P2口的行列电平数据
ANL A,#0F0H                   ；通过判断行列线电平是否为#0FH来判断是否有键被按下
CJNE A,#0F0H,KK1              ；若行列电平不为#0FH则跳转到去抖函数
AJMP KEY2                     ；若行列电平仍然为#0F0H则说明刚刚的电平变化是干扰，跳转至首句继续判断是否有键按下
KK1:LCALL DELAY                ；调用延时函数
MOV P2,#0F0H
MOV A,P2
ANL A,#0F0H
CJNE A,#0F0H,KKE              ；重新通过判断行列线电平是否为#0FH判断是否有键按下，若还是有键按下则跳转到反极性判断函数函数
AJMP KEY2                     ；若行列电平不变则说明刚刚的电平变化是干扰，跳转至首句继续判断是否有键按下
KKE:                         ；反极性判断函数
MOV R3,A                    ；保存行线为零，有键按下时，P2口的电平数据
KEY3:MOV P2,#0FH            ；将行线P2.0,P2.1,P2.2,P2.3置1，列线P2.4,P2.5,P2.6,P2.7置0
MOV A,P2                    ；调转极性，保存P2口的行列电平数据
ANL A,#0FH                   ；通过判断行列线电平是否为#0FH来判断是否有键被按下
CJNE A,#0FH,KK2               ；若行列电平不为#0FH则跳转到去抖函数进一步判断
AJMP KEY2                     ；若行列电平仍然为#0FH则说明刚刚的电平变化是干扰，跳转至首句继续判断是否有键按下
KK2:LCALL DELAY                ；调用延时函数
MOV P2,#0FH
MOV A,P2
ANL A,#0FH
CJNE A,#0FH,KKE2             ；重新通过判断行列线电平是否为#0FH判断是否有键按下，若还是有键按下则跳转到取键值函数	
AJMP KEY2                     ；若行列电平仍然为#0FH则说明刚刚的电平变化是干扰，跳转至首句继续判断是否有键按下
KKE2:                          ；取键值函数
ORL A,R3                       ；将行线为0列线为1的P2口电平数据与列线为0行线为1的P2口电平相异或，得到按键位置的信息
MOV B,A                        ；在后续的程序中A寄存器还会被利用，故用B寄存器保留按键信息
MOV R1,#16                     ；用于给键值的判断计次
MOV A,#0                       ；将A初值设置为零，实际意义是相对于KEYT表头的地址的偏移量
MOV DPTR,#KEYT                 ；取表头的地址
GO5:
PUSH ACC                       ；保存寄存器A中的原有数据
MOVC A,@A+DPTR                ；取KEYT表中的第(A+1)个数据的值并保存到A中，其在内存中的地址是A+DPTR
CJNE A,B,GO6                    ；判断按下的是否是第（A+1）个键，若不是则跳转到GO6语句
POP ACC                         ；释放寄存器A，此时A寄存器中的值是按键的序号
MOV R0,A                        ；将按键的键值保存在R0寄存器中
XRL A,#0FH                       ；判断是否是最后一个按键
CJNE A,#00H,OUT1                 ；如果是最后一个按键则将功能切换至数码管功能否则执行键盘控制LED灯程序
SETB P0.0
SETB P0.1
SETB P0.2
SETB P0.3                        ；为数码管设置初值，将四位数码管全部点亮
LCALL DIG                        ；调用外部数码管函数
GO6:
POP ACC                         ；释放寄存器A，此时A寄存器中的值是按键的序号
INC A                            ；将A值加1，进行下一个键的判断
DJNZ R1,GO5                      ；判断16个键是否全部查询结束
OUT1:                            ；键控LED灯函数
MOV A,R0                         ；将键号赋值给A
MOV   DPTR, #TABLE2              ；取TABLE表头的地址
MOV B,A
MOV A,B
MOV R5,A                        ；保存键号值
MOVC  A, @A+DPTR               ；将表中第(A+1)个数值取出存放到A中
CPL A                            ；将A取反，因为P0输出低电平才使得LED灯点     亮，而表中数据将想要被点亮的灯所对应的P0.x端口设置为1其余位为0。实际需要P0.x端口输出为0，其余位为1，才能点亮LED
MOV  P0, A                      ；给端口赋值，点亮LED
LCALL DELAY                      ；延时函数
AJMP KEY2                       ；跳转至首句
OUT2:RET                        ；返回MAIN函数
KEYT: DB 77H,7BH,7DH,7EH,0B7H,0BBH,0BDH,0BEH,0D7H,0DBH,0DDH,0DEH,0E7H,0EBH,0EDH,0EEH
                             ；用于存放按键信息的表。即按下某个键，将行线为0列线为1的P2口电平数据与列线为0行线为1的P2口电平相异或之后得到按键位置的信息。（前四个数据代表第一行的四个键，四到八数据代表第二行的四个键，以此类推。类似地，第一行四个键键号为0到3，第二行四个键键号为4到7。以此类推）
TABLE2: DB	00000001B	
	DB	00000010B	
	DB	00000100B	
	DB	00001000B	
	DB	00010000B	
	DB	00100000B	
	DB	01000000B	
	DB	10000000B	
	DB	00000001B	
	DB	00000010B	
	DB	00000100B	
	DB	00001000B	
	DB	00010000B	
	DB	00100000B	
	DB	01000000B	
	DB	10000000B	
END
