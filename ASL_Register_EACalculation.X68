*Also works for ASR, LSL, LSR, ROL, ROR (register shifts only)
    ORG    $1000
START:                 
*Get first three bits (destination register)
            ADD.B   D0, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
ASLREGLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLREGADD1
ASLREGCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLREGNEXT1
            JMP     ASLREGLOOP1
    
*Skip next two bits
ASLREGNEXT1:
            ROL     #3, D3
            LSR     #2, D2
            
*Get next bit (i/r)
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLREGADD2           
            
*Skip three bits 
ASLREGNEXT2:
            LSR     #3, D2

*Get next three bits (count/register)
            MOVE    #3, D4
ASLREGLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLREGADD3
ASLREGCONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLREGNEXT3
            JMP     ASLREGLOOP2
            
*Decide if we are set to count or register
ASLREGNEXT3:    
            CMP     #0, D5
            BEQ     ASLREGCOUNT
*Register goes here:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH       
            
ASLREGCOUNT:
            MOVE.B  #'#', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH
            
ASLREGADD1:
            ADDI    #1, D3
            JMP     ASLREGCONTINUE1
    
ASLREGADD2:
            ADDI    #1, D5
            JMP     ASLREGNEXT2
ASLREGADD3:
            ADDI    #1, D6
            JMP     ASLREGCONTINUE3    
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
