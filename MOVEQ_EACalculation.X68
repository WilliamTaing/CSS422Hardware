    ORG    $1000
START:                 
*Get first eight bits (data)
            MOVEQ   #100, D1
            MOVEA   $1002, A4
            MOVEA   A1, A2
            MOVE    #8, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
MOVEQLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEQADD1
MOVEQCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEQNEXT1
            JMP     MOVEQLOOP1
    
*Skip next bit
MOVEQNEXT1:
            ROL     #8, D3
            LSR     #1, D2
            
*Get next three bits (destination register)   
            MOVE    #3, D4
MOVEQLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEQADD2
MOVEQCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEQNEXT2
            JMP     MOVEQLOOP2

*Print out EA
MOVEQNEXT2:
            MOVE    #4, D4
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
MOVEQLOOP3:
            MOVE.B  D3, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEQSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEQCONTINUE3:  
            SUB     #1, D4
            LSR     #4, D3
            CMPI    #0, D4
            BEQ     MOVEQNEXT3
            JMP     MOVEQLOOP3
            
MOVEQSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEQCONTINUE3

MOVEQNEXT3:
            MOVE    #4, D4
MOVEQLOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEQNEXT4
            JMP     MOVEQLOOP4
MOVEQNEXT4:           
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D5
            MOVE.B  D5, (A2)+
            JMP     FINISH
            
MOVEQADD1:
            ADDI    #1, D3
            JMP     MOVEQCONTINUE1
    
MOVEQADD2:
            ADDI    #1, D5
            JMP     MOVEQCONTINUE2          

            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
