 $INCLUDE(key2.inc)
  $INCLUDE(flo2.inc)
  $INCLUDE(delay.inc)                
  $INCLUDE(dig.inc)                  
  $INCLUDE(digi.inc)
    ORG    0000H
    LJMP   MAIN
    ORG    0003H
    LJMP   IN0           
    ORG 0013H
    LJMP FLO21
    ORG 000BH
    LJMP TIME0
    ORG 0030H                       
MAIN:
   MOV SP,#30H                 
   MOV TMOD,#01H
   MOV TH0,#0FEH
   MOV TL0,#0CH                   
   CLR IT0
   CLR IT1                          
   SETB EA                      
   SETB EX0
   SETB EX1                        
   SETB PX0                      
   SETB ET0                       
   RUNE:    
   NOP
   LCALL KEY2                      
   AJMP RUNE   
                                                                    
IN0:                               
   NOP
   LJMP SECDUE0
RETI


FLO21:
  NOP
  MOV R6,#0FEH                              
  MOV R7,#50H                                
  MOV A,R6
  SETB TR0                                  
RETI
