*Also works for SUBI
    ORG    $1000
START:                 
*Get first three bits (destination register)
            ADDI.L  #$1000000, $10000
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVEA   #$1002, A4
            MOVE    (A0), D2
ADDILOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDIADD1
ADDICONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDINEXT1
            JMP     ADDILOOP1
    
*Get next three bits (destination mode)
ADDINEXT1:
            ROL     #3, D3
            MOVE    #3, D4
ADDILOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDIADD2
ADDICONTINUE2:
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDINEXT2
            JMP     ADDILOOP2

*Get next three bits (size)
ADDINEXT2:
            ROL     #3, D5
            MOVE    #3, D4
ADDILOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDIADD3
ADDICONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDINEXT3
            JMP     ADDILOOP3

*Determine size of immediate:
ADDINEXT3:
            ROL     #3, D6
            CMPI    #0, D6
            BEQ     ADDIBYTE
            CMPI    #1, D6
            BEQ     ADDIWORD
            CMPI    #2, D6
            BEQ     ADDILONG
            
ADDIBYTE:
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
            MOVE    (A4)+, D7
            MOVE    #2, D4
ADDIBYTELOOP1:
            MOVE.B  D7, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDISINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDIBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D7
            CMPI    #0, D4
            BEQ     ADDINEXT9
            JMP     ADDIBYTELOOP1
            
ADDISINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDIBYTECONTINUE1

ADDINEXT9:
            MOVE    #2, D4
ADDIBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDIBYTENEXT1
            JMP     ADDIBYTELOOP2
            
ADDIBYTENEXT1:
            MOVE.B  #' ', (A2)+
            JMP     ADDINEXT4
 
ADDIWORD:       
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
            MOVE    (A4)+, D7
            MOVE    #4, D4
ADDIWORDLOOP1:
            MOVE.B  D7, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDISINGLEDGT4
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDIWORDCONTINUE1:
            SUB     #1, D4
            LSR     #4, D7
            CMPI    #0, D4
            BEQ     ADDINEXT10
            JMP     ADDIWORDLOOP1
            
ADDISINGLEDGT4:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDIWORDCONTINUE1

ADDINEXT10:
            MOVE    #4, D4
ADDIWORDLOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDIWORDNEXT1
            JMP     ADDIWORDLOOP2
            
ADDIWORDNEXT1:
            MOVE.B  #' ', (A2)+
            JMP     ADDINEXT4
            
ADDILONG:
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4)+, D7
            MOVE    #8, D4
ADDILONGLOOP1:
            MOVE.B  D7, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDISINGLEDGT5
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDILONGCONTINUE1:
            SUB     #1, D4
            LSR.L   #4, D7
            CMPI    #0, D4
            BEQ     ADDINEXT11
            JMP     ADDILONGLOOP1
            
ADDISINGLEDGT5:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDILONGCONTINUE1

ADDINEXT11:
            MOVE    #8, D4
ADDILONGLOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDILONGNEXT1
            JMP     ADDILONGLOOP2
            
ADDILONGNEXT1:
            MOVE.B  #' ', (A2)+
            JMP     ADDINEXT4

*Print out destination mode
ADDINEXT4:
            ROL     #3, D6
            CMPI    #0, D5
            BEQ     ADDIDA
            CMPI    #1, D5
            BEQ     ADDIAA
            CMPI    #2, D5
            BEQ     ADDIDEREGISTERAA
            CMPI    #3, D5
            BEQ     ADDIPOSTADDAA
            CMPI    #4, D5
            BEQ     ADDIPRESUBAA
            CMPI    #5, D5
            BEQ     ADDID16AA
            CMPI    #6, D5
            BEQ     ADDID8AXA
            CMPI    #7, D5
            BEQ     ADDIWLD1
            
ADDIWLD1:
            CMPI    #0, D3
            BEQ     ADDIWORDA
            CMPI    #1, D3
            BEQ     ADDILONGA
            
ADDIADD1:
            ADDI    #1, D3
            JMP     ADDICONTINUE1
    
ADDIADD2:
            ADDI    #1, D5
            JMP     ADDICONTINUE2
ADDIADD3:
            ADDI    #1, D6
            JMP     ADDICONTINUE3
    
ADDIDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH
ADDIAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH
ADDIDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH 
ADDIPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     FINISH 
ADDIPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
ADDID16AA:
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
ADDID8AXA:
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
            
ADDIWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ADDILOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDISINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDICONTINUE4:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDINEXT5
            JMP     ADDILOOP4
            
ADDISINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDICONTINUE4

ADDINEXT5:
            MOVE    #4, D4
ADDILOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDINEXT6
            JMP     ADDILOOP5
ADDINEXT6:            
            JMP     FINISH
            
ADDILONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ADDILOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDISINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDICONTINUE5:
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ADDINEXT7
            JMP     ADDILOOP6
            
ADDISINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDICONTINUE5

ADDINEXT7:
            MOVE    #8, D4
ADDILOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDINEXT8
            JMP     ADDILOOP7
ADDINEXT8:            
            JMP     FINISH
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
