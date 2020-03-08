*Also works for LEA
    ORG    $1000
START:                 
*Get first three bits (source register)
            MOVEA   D1, A3
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1002, A0
            MOVE    (A0), D2
MOVEALOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEAADD1
MOVEACONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT1
            JMP     MOVEALOOP1
    
*Get next three bits (source mode)
MOVEANEXT1:
            ROL     #3, D3
            MOVE    #3, D4
MOVEALOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEAADD2
MOVEACONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT2
            JMP     MOVEALOOP2
            
*Skip next three bits (not needed)
MOVEANEXT2:
            ROL     #3, D5
            LSR     #3, D2          
*Get next three bits (destination register)
            MOVE    #3, D4
MOVEALOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEAADD3
MOVEACONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT3
            JMP     MOVEALOOP3

*Get next two bits (size)
MOVEANEXT3:
            ROL     #3, D6
            MOVE    #2, D4
MOVEALOOP4:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEAADD4
MOVEACONTINUE4:  
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEASOURCE
            JMP     MOVEALOOP4
            

*Print out source address
MOVEASOURCE:
            CMPI    #0, D5
            BEQ     MOVEADA
            CMPI    #1, D5
            BEQ     MOVEAAA
            CMPI    #2, D5
            BEQ     MOVEADEREGISTERAA
            CMPI    #3, D5
            BEQ     MOVEAPOSTADDAA
            CMPI    #4, D5
            BEQ     MOVEAPRESUBAA
            CMPI    #5, D5
            BEQ     MOVEAD16AA
            CMPI    #6, D5
            BEQ     MOVEAD8AXA
            CMPI    #7, D5
            BEQ     MOVEAWLD1
            
*Print out destination address
MOVEANEXT5:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     FINISH
            
MOVEAWLD1:
            CMPI    #0, D3
            BEQ     MOVEAWORDA
            CMPI    #1, D3
            BEQ     MOVEALONGA
            CMPI    #4, D3
            BEQ     MOVEADATAA
            
MOVEAADD1:
            ADDI    #1, D3
            JMP     MOVEACONTINUE1
    
MOVEAADD2:
            ADDI    #1, D5
            JMP     MOVEACONTINUE2
MOVEAADD3:
            ADDI    #1, D6
            JMP     MOVEACONTINUE3

MOVEAADD4:
            ADDI    #1, D1
            JMP     MOVEACONTINUE4
    
MOVEADA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
MOVEAAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
MOVEADEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5 
MOVEAPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5 
MOVEAPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
MOVEAD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
MOVEAD8AXA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'X', (A2)+
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
            
MOVEAWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
MOVEALOOP5:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEASINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEACONTINUE5:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVEANEXT6
            JMP     MOVEALOOP5
            
MOVEASINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEACONTINUE5

MOVEANEXT6:
            MOVE    #4, D4
MOVEALOOP6:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT7
            JMP     MOVEALOOP6
MOVEANEXT7:            
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
            
MOVEALONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
MOVEALOOP7:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEASINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEACONTINUE6:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MOVEANEXT8
            JMP     MOVEALOOP7
            
MOVEASINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEACONTINUE6

MOVEANEXT8:
            MOVE    #8, D4
MOVEALOOP8:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT9
            JMP     MOVEALOOP8
MOVEANEXT9:            
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5

            
MOVEADATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     MOVEAWORDA
            CMPI    #2, D1
            BEQ     MOVEALONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
MOVEABYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEASINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEABYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVEANEXT10
            JMP     MOVEABYTELOOP1
            
MOVEASINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEABYTECONTINUE1

MOVEANEXT10:
            MOVE    #2, D4
MOVEABYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEABYTENEXT1
            JMP     MOVEABYTELOOP2
            
MOVEABYTENEXT1:
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5


FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
