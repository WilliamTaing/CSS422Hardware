*Also works for ASR, LSL, LSR, ROL, ROR (Memory mode only)
    ORG    $1000
START:                 
*Get first three bits (register)
            MOVE    D4, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
ASLMEMLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLMEMADD1
ASLMEMCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLMEMNEXT1
            JMP     ASLMEMLOOP1
    
*Get next three bits (mode)
ASLMEMNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
ASLMEMLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLMEMADD2
ASLMEMCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLMEMNEXT2
            JMP     ASLMEMLOOP2

*Print out EA
ASLMEMNEXT2:
            CMPI    #0, D5
            BEQ     ASLMEMDA
            CMPI    #1, D5
            BEQ     ASLMEMAA
            CMPI    #2, D5
            BEQ     ASLMEMDEREGISTERAA
            CMPI    #3, D5
            BEQ     ASLMEMPOSTADDAA
            CMPI    #4, D5
            BEQ     ASLMEMPRESUBAA
            CMPI    #5, D5
            BEQ     ASLMEMD16AA
            CMPI    #6, D5
            BEQ     ASLMEMD8AXA
            CMPI    #7, D5
            BEQ     ASLMEMWLD1

ASLMEMWLD1:
            CMPI    #0, D3
            BEQ     ASLMEMWORDA
            CMPI    #1, D3
            BEQ     ASLMEMLONGA
            
ASLMEMADD1:
            ADDI    #1, D3
            JMP     ASLMEMCONTINUE1
    
ASLMEMADD2:
            ADDI    #1, D5
            JMP     ASLMEMCONTINUE2
    
ASLMEMDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
ASLMEMAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
ASLMEMDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH 
ASLMEMPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH 
ASLMEMPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
ASLMEMD16AA:
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
ASLMEMD8AXA:
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
            
ASLMEMWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ASLMEMLOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ASLMEMSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ASLMEMCONTINUE4:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ASLMEMNEXT3
            JMP     ASLMEMLOOP4
            
ASLMEMSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ASLMEMCONTINUE4

ASLMEMNEXT3:
            MOVE    #4, D4
ASLMEMLOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     FINISH
            JMP     ASLMEMLOOP5
            
ASLMEMLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ASLMEMLOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ASLMEMSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ASLMEMCONTINUE5:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ASLMEMNEXT4
            JMP     ASLMEMLOOP6
            
ASLMEMSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ASLMEMCONTINUE5

ASLMEMNEXT4:
            MOVE    #8, D4
ASLMEMLOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     FINISH
            JMP     ASLMEMLOOP7
                        
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
