    ORG    $1000
START:                 
*Get first three bits (source register)
            MOVE    $10000000, D1
            MOVEA   #$1002, A4
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
    
*Get next three bits (source mode)
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
            
*Get next three bits (destination mode)   
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
            
*Get next three bits (destination register)
NEXT3:
            ROL     #3, D6
            MOVE    #3, D4
LOOP4:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADD4
CONTINUE4:  ROR     #1, D7
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT4
            JMP     LOOP4
            
*Get next two bits (size)
NEXT4:
            ROL     #3, D7
            MOVE    #2, D4
LOOP5:      
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADD5
CONTINUE5:  ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     SOURCE
            JMP     LOOP5

*Print out source address
SOURCE:
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
            CMPI    #6, D5
            BEQ     WLD1
          
*Check register
WLD1:
            CMPI    #0, D3
            BEQ     WORDA
            CMPI    #1, D3
            BEQ     LONGA
            CMPI    #4, D3
            BEQ     DATAA
            
*Print out destination address
NEXT5:
            CMPI    #0, D6
            BEQ     DB
            CMPI    #1, D6
            BEQ     AB
            CMPI    #2, D6
            BEQ     DEREGISTERAB
            CMPI    #3, D6
            BEQ     POSTADDAB
            CMPI    #4, D6
            BEQ     PRESUBAB
            CMPI    #5, D6
            BEQ     D16AB
            CMPI    #6, D6
            BEQ     D8AXB
            CMPI    #7, D6
            BEQ     WLD2
            
*Check register
WLD2:
            CMPI    #0, D7
            BEQ     WORDB
            CMPI    #1, D7
            BEQ     LONGB
            CMPI    #4, D7
            BEQ     DATAB
            
ADD1:
            ADDI    #1, D3
            JMP     CONTINUE1
    
ADD2:
            ADDI    #1, D5
            JMP     CONTINUE2
ADD3:
            ADDI    #1, D6
            JMP     CONTINUE3
ADD4:
            ADDI    #1, D7
            JMP     CONTINUE4
ADD5:
            ADDI    #1, D1
            JMP     CONTINUE5
    
DA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     NEXT5
AA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     NEXT5
DEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     NEXT5 
POSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     NEXT5 
PRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     NEXT5
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
            JMP     NEXT5
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
            JMP     NEXT5
            
WORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
LOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CONTINUE6:  SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     NEXT7
            JMP     LOOP6
            
SINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE6

NEXT7:
            MOVE    #4, D4
LOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT8
            JMP     LOOP7
NEXT8:            
            MOVE.B  #' ', (A2)+
            JMP     NEXT5
            
LONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
LOOP8:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CONTINUE7:  SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     NEXT9
            JMP     LOOP8
            
SINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE7

NEXT9:
            MOVE    #8, D4
LOOP9:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT10
            JMP     LOOP9
NEXT10:            
            MOVE.B  #' ', (A2)+
            JMP     NEXT5

            
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
            BEQ     NEXT11
            JMP     BYTELOOP1
            
SINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     BYTECONTINUE1

NEXT11:
            MOVE    #2, D4
BYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     BYTENEXT1
            JMP     BYTELOOP2
            
BYTENEXT1:
            MOVE.B  #' ', (A2)+
            JMP     NEXT5
            
DB:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     FINISH
AB:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     FINISH
DEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH 
POSTADDAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     FINISH 
PRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
D16AB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
D8AXB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'X', (A2)+
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
            
WORDB:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
LOOP10:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT4
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CONTINUE9:  SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     NEXT12
            JMP     LOOP10
            
SINGLEDGT4:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE6

NEXT12:
            MOVE    #4, D4
LOOP11:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT13
            JMP     LOOP11
NEXT13:            
            JMP     FINISH
            
LONGB:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
LOOP12:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT5
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CONTINUE10: SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     NEXT14
            JMP     LOOP12
            
SINGLEDGT5:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE10

NEXT14:
            MOVE    #8, D4
LOOP13:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT14
            JMP     LOOP13
NEXT15:            
            JMP     FINISH

            
DATAB:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     WORDA
            CMPI    #2, D1
            BEQ     LONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
BYTELOOP3:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     SINGLEDGT6
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
BYTECONTINUE2:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     NEXT16
            JMP     BYTELOOP3
            
SINGLEDGT6:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     BYTECONTINUE2

NEXT16:
            MOVE    #2, D4
BYTELOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     BYTENEXT2
            JMP     BYTELOOP4
BYTENEXT2:
            JMP     FINISH


            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
