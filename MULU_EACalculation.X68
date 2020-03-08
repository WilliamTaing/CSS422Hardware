*Also works for MULS and DIVU
    ORG    $1000
START:                 
*Get first three bits (source register)
            ADD.B   D0, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
MULULOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MULUADD1
MULUCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUNEXT1
            JMP     MULULOOP1
    
*Get next three bits (source mode)
MULUNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
MULULOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MULUADD2
MULUCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUNEXT2
            JMP     MULULOOP2
            
            
*Skip three bits   
MULUNEXT2:
            ROL     #3, D5
            LSR     #3, D2

*Get next three bits (destination register)
            MOVE    #3, D4
MULULOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MULUADD3
MULUCONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUNEXT3
            JMP     MULULOOP3
            
*Print address
MULUNEXT3:    
            CMPI    #0, D5
            BEQ     MULUDA
            CMPI    #1, D5
            BEQ     MULUAA
            CMPI    #2, D5
            BEQ     MULUDEREGISTERAA
            CMPI    #3, D5
            BEQ     MULUPOSTADDAA
            CMPI    #4, D5
            BEQ     MULUPRESUBAA
            CMPI    #5, D5
            BEQ     MULUD16AA
            CMPI    #6, D5
            BEQ     MULUD8AXA
            CMPI    #7, D5
            BEQ     MULUWLD1
MULUCONTINUE5:  
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            JMP     FINISH
            
MULUWLD1:
            CMPI    #0, D3
            BEQ     MULUWORDA
            CMPI    #1, D3
            BEQ     MULULONGA
            CMPI    #4, D3
            BEQ     MULUDATAA
            
MULUADD1:
            ADDI    #1, D3
            JMP     MULUCONTINUE1
    
MULUADD2:
            ADDI    #1, D5
            JMP     MULUCONTINUE2
MULUADD3:
            ADDI    #1, D6
            JMP     MULUCONTINUE3
    
MULUDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     MULUCONTINUE5
MULUAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     MULUCONTINUE5
MULUDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULUCONTINUE5
MULUPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     MULUCONTINUE5
MULUPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULUCONTINUE5
MULUD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULUCONTINUE5
MULUD8AXA:
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
            JMP     MULUCONTINUE5
                   
MULUWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
MULULOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULUSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULUCONTINUE6:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MULUNEXT4
            JMP     MULULOOP4
            
MULUSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULUCONTINUE6

MULUNEXT4:
            MOVE    #4, D4
MULULOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUCONTINUE5
            JMP     MULULOOP5
            
MULULONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
MULULOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULUSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULUCONTINUE7:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MULUNEXT5
            JMP     MULULOOP6
            
MULUSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULUCONTINUE7

MULUNEXT5:
            MOVE    #8, D4
MULULOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUCONTINUE5
            JMP     MULULOOP7
            
MULUDATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     MULUWORDA
            CMPI    #2, D1
            BEQ     MULULONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
MULUBYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULUSINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULUBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MULUNEXT6
            JMP     MULUBYTELOOP1
            
MULUSINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULUBYTECONTINUE1

MULUNEXT6:
            MOVE    #2, D4
MULUBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUBYTENEXT1
            JMP     MULUBYTELOOP2
            
MULUBYTENEXT1:
            JMP     MULUCONTINUE5
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
