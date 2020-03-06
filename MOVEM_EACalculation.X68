*Also works for JSR and memory shifts for ASL, ASR, LSL, LSR, ROL, ROR
    ORG    $1000
START:                 
*Get first three bits (register)
            MOVE    D4, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
LOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADD1
CONTINUE1:  ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT1
            JMP     LOOP1
    
*Get next three bits (mode)
NEXT1:
            ROL     #3, D3
            MOVE    #3, D4
LOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADD2
CONTINUE2:  ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT2
            JMP     LOOP2

*Print out EA
NEXT4:
            ROL     #3, D6
            CMPI    #0, D5
            BEQ     DA
            CMPI    #1, D5
            BEQ     AA
            CMPI    #2, D5
            BEQ     DEREGISTERAA
            CMPI    #3, D5
            BEQ     POSTADDAA
            CMPI    #4, D5
            BEQ     PRESUBAA
            CMPI    #5, D5
            BEQ     D16AA
            CMPI    #6, D5
            BEQ     D8AXA
            CMPI    #7, D5
            BEQ     WLD1

WLD1:
            CMPI    #0, D3
            BEQ     WORDA
            CMPI    #1, D3
            BEQ     LONGA
            CMPI    #4, D3
            BEQ     DATAA
            
ADD1:
            ADDI    #1, D3
            JMP     CONTINUE1
    
ADD2:
            ADDI    #1, D5
            JMP     CONTINUE2
ADD3:
            ADDI    #1, D6
            JMP     CONTINUE3
    
DA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
AA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
DEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH 
POSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH 
PRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
D16AA:
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
            JMP     FINISH
D8AXA:
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
            JMP     FINISH
            
WORDA:
            MOVE.B  #'$', (A2)+
            CLR     D5
            ADD     #'0', D5
            MOVE.W  (A4)+, D5
            MOVE.B  #' ', (A2)+
            JMP     NEXT5
            
LONGA:
            MOVE.B  #'$', (A2)+
            CLR     D5
            ADD     #'0', D5
            MOVE.L  (A4)+, D5
            MOVE.B  #' ', (A2)+
            JMP     NEXT5
            
DATAA:
            MOVE.B  #'#', (A2)+
            CLR     D5
            ADD     #'0', D5
            MOVE    (A4)+, D5
            MOVE.B  #' ', (A2)+
            JMP     NEXT5
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
