*Also works for SUBI
    ORG    $1000
START:                 
*Get first three bits (destination register)
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
    
*Get next three bits (destination mode)
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

*Get next three bits (size)
NEXT2:
            ROL     #3, D5
            MOVE    #3, D4
LOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADD3
CONTINUE3:  ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT3
            JMP     LOOP3

*Determine size of immediate:
NEXT3:
            ROL     #3, D6
            CMPI    #0, D6
            BEQ     BYTE
            CMPI    #1, D6
            BEQ     WORD
            CMPI    #2, D6
            BEQ     LONG
            
BYTE:
            CLR     D6
            MOVE.B  #'#', (A2)+
            ADD     #'0', D6
            MOVE.B  (A4)+, D6
            MOVE    D6, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     NEXT4
            
WORD:       
            CLR     D6
            MOVE.B  #'#', (A2)+
            ADD     #'0', (A2)+
            MOVE.W  (A4)+, D6
            MOVE    D6, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     NEXT4
            
LONG:
            CLR     D6
            MOVE.B  #'#', (A2)+
            ADD     #'0', (A2)+
            *TODO
            JMP     NEXT4

*Print out destination mode
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
            CMPI    #7, WLD1
            
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
            JMP     FINISH
AA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH
DEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH 
POSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     FINISH 
PRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
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
            JMP     FINISH
            
WORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
LOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CONTINUE4:  SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     NEXT5
            JMP     LOOP4
            
SINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE4

NEXT5:
            MOVE    #4, D4
LOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT6
            JMP     LOOP5
NEXT6:            
            JMP     FINISH
            
LONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
LOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CONTINUE5:  SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     NEXT7
            JMP     LOOP6
            
SINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE5

NEXT7:
            MOVE    #8, D4
LOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT8
            JMP     LOOP7
NEXT8:            
            JMP     FINISH

            
DATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     WORDA
            CMPI    #2, D1
            BEQ     LONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
BYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
BYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     NEXT9
            JMP     BYTELOOP1
            
SINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     BYTECONTINUE1

NEXT9:
            MOVE    #2, D4
BYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     BYTENEXT1
            JMP     BYTELOOP2
            
BYTENEXT1:
            JMP     FINISH

            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
