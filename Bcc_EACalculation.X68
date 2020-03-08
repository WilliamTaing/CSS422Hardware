    ORG    $1000
START:                 
*Get first eight bits (8-bit displacement)
            MOVEA   A1, A2
            MOVE    #8, D4
            MOVEA   #$1002, A4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
BCCLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     BCCADD1
BCCCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     BCCNEXT1
            JMP     BCCLOOP1
BCCNEXT1:
*Get current address (A4 - 2)
            ROL     #8, D3
            MOVE    (A4), D6
*See if we are getting byte displacement, word displacement, or long displacement
            CMPI    #$00, D3
            BEQ     BCCWORDDIS
            CMPI    #$FF, D3
            BEQ     BCCLONGDIS
*If code reached here, we're byte displacement
            ADD.B   D3, D6
            JMP     BCCNEXT2

BCCWORDDIS:
            MOVE    A4, D5
            ADD     D5, D6
            JMP     BCCNEXT2

BCCLONGDIS:
            MOVE.L  (A4), D5
            ADD.L   D5, D6
            JMP     BCCNEXT2
            
*Print out current address plus displacement
BCCNEXT2:
            MOVE.B  #'$', (A2)+
            MOVE    #8, D4
BCCLOOP2:
            MOVE.B  D6, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     BCCSINGLEDGT1
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
BCCCONTINUE2:  
            SUB     #1, D4
            LSR.L   #4, D6
            CMPI    #0, D4
            BEQ     BCCNEXT3
            JMP     BCCLOOP2
            
BCCSINGLEDGT1:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     BCCCONTINUE2

BCCNEXT3:
            MOVE    #8, D4
BCCLOOP3:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ    FINISH
            JMP     BCCLOOP3
            
BCCADD1:
            ADDI    #1, D3
            JMP     BCCCONTINUE1       
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
