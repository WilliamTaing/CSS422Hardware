    ORG    $1000
START:                 
*Get first eight bits (data)
            MOVEQ   #100, D1
            MOVEA   $1002, A4
            MOVEA   A1, A2
            MOVE    #8, D4
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
    
*Skip next bit
NEXT1:
            ROL     #8, D3
            LSR     #1, D2
            
*Get next three bits (destination register)   
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
NEXT2:
            MOVE    #4, D4
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
LOOP3:
            MOVE.B  D3, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CONTINUE3:  SUB     #1, D4
            LSR     #4, D3
            CMPI    #0, D4
            BEQ     NEXT3
            JMP     LOOP3
            
SINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE3

NEXT3:
            MOVE    #4, D4
LOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT4
            JMP     LOOP4
NEXT4:           
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D5
            MOVE.B  D5, (A2)+
            JMP     FINISH
            
ADD1:
            ADDI    #1, D3
            JMP     CONTINUE1
    
ADD2:
            ADDI    #1, D5
            JMP     CONTINUE2          

            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
