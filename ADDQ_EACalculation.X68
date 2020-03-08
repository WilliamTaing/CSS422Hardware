    ORG    $1000
START:                 
*Get first three bits (destination register)
            MOVE    D4, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
ADDQLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDQADD1
ADDQCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQNEXT1
            JMP     ADDQLOOP1
    
*Get next three bits (destination mode)
ADDQNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
ADDQLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDQADD2
ADDQCONTINUE2:
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQNEXT2
            JMP     ADDQLOOP2
            
*Get next two bits (size)
ADDQNEXT2:
            ROL     #3, D5
            MOVE    #3, D4
ADDQSIZELOOP:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDQADD4
ADDQSIZECONTINUE:
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQNEXTSIZE
            JMP     ADDQSIZELOOP
            
*Skip next bit
ADDQNEXTSIZE:
            LSR     #1, D2

*Get next three bits (data)
            MOVE    #3, D4
ADDQLOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDQADD3
ADDQCONTINUE3:
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQNEXT3
            JMP     ADDQLOOP3

*Print out data:
ADDQNEXT3:
            ROL     #3, D6
            MOVE.B  #'#', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            MOVE.B  #' ', (A2)+

*Print out destination mode
            CMPI    #0, D5
            BEQ     ADDQDA
            CMPI    #1, D5
            BEQ     ADDQAA
            CMPI    #2, D5
            BEQ     ADDQDEREGISTERAA
            CMPI    #3, D5
            BEQ     ADDQPOSTADDAA
            CMPI    #4, D5
            BEQ     ADDQPRESUBAA
            CMPI    #5, D5
            BEQ     ADDQD16AA
            CMPI    #6, D5
            BEQ     ADDQD8AXA
            CMPI    #7, D5
            BEQ     ADDQWLD1        
ADDQWLD1:
            CMPI    #0, D1
            BEQ     ADDQWORDA
            CMPI    #1, D1
            BEQ     ADDQLONGA
            CMPI    #4, D1
            BEQ     ADDQDATAA
            
ADDQADD1:
            ADDI    #1, D3
            JMP     ADDQCONTINUE1
    
ADDQADD2:
            ADDI    #1, D5
            JMP     ADDQCONTINUE2
ADDQADD3:
            ADDI    #1, D6
            JMP     ADDQCONTINUE3
ADDQADD4:
            ADDI    #1, D1
            JMP     ADDQSIZECONTINUE
    
ADDQDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH
ADDQAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH

ADDQDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH 

ADDQPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     FINISH 

ADDQPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH

ADDQD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
ADDQD8AXA:
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
            JMP     FINISH
            
ADDQWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ADDQLOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDQSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDQCONTINUE4:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDQNEXT4
            JMP     ADDQLOOP4
            
ADDQSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDQCONTINUE4

ADDQNEXT4:
            MOVE    #4, D4
ADDQLOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     FINISH
            JMP     ADDQLOOP5
ADDQLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ADDQLOOP8:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDQSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDQCONTINUE7:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ADDQNEXT5
            JMP     ADDQLOOP8
            
ADDQSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDQCONTINUE7

ADDQNEXT5:
            MOVE    #8, D4
ADDQLOOP9:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     FINISH
            JMP     ADDQLOOP9
            
ADDQDATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     ADDQWORDA
            CMPI    #2, D1
            BEQ     ADDQLONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
ADDQBYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDQSINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDQBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDQNEXT6
            JMP     ADDQBYTELOOP1
            
ADDQSINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDQBYTECONTINUE1

ADDQNEXT6:
            MOVE    #2, D4
ADDQBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQBYTENEXT1
            JMP     ADDQBYTELOOP2
            
ADDQBYTENEXT1:
            JMP     FINISH
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
