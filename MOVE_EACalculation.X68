    ORG    $1000
START:                 
*Get first three bits (source register)
            MOVE    $10000000, D1
            MOVEA   #$1002, A4
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
MOVELOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEADD1
MOVECONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVENEXT1
            JMP     MOVELOOP1
    
*Get next three bits (source mode)
MOVENEXT1:
            ROL     #3, D3
            MOVE    #3, D4
MOVELOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEADD2
MOVECONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVENEXT2
            JMP     MOVELOOP2
            
*Get next three bits (destination mode)   
MOVENEXT2:
            ROL     #3, D5
            MOVE    #3, D4
MOVELOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEADD3
MOVECONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVENEXT3
            JMP     MOVELOOP3
            
*Get next three bits (destination register)
MOVENEXT3:
            ROL     #3, D6
            MOVE    #3, D4
MOVELOOP4:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEADD4
MOVECONTINUE4:  
            ROR     #1, D7
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVENEXT4
            JMP     MOVELOOP4
            
*Get next two bits (size)
MOVENEXT4:
            ROL     #3, D7
            MOVE    #2, D4
MOVELOOP5:      
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEADD5
MOVECONTINUE5:  
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVESOURCE
            JMP     MOVELOOP5

*Print out source address
MOVESOURCE:
            CMPI    #0, D5
            BEQ     MOVEDA
            CMPI    #1, D5
            BEQ     MOVEAA
            CMPI    #2, D5
            BEQ     MOVEDEREGISTERAA
            CMPI    #3, D5
            BEQ     MOVEPOSTADDAA
            CMPI    #4, D5
            BEQ     MOVEPRESUBAA
            CMPI    #5, D5
            BEQ     MOVED16AA
            CMPI    #6, D5
            BEQ     MOVED8AXA
            CMPI    #7, D5
            BEQ     MOVEWLD1
          
*Check register
MOVEWLD1:
            CMPI    #0, D3
            BEQ     MOVEWORDA
            CMPI    #1, D3
            BEQ     MOVELONGA
            CMPI    #4, D3
            BEQ     MOVEDATAA
            
*Print out destination address
MOVENEXT5:
            CMPI    #0, D6
            BEQ     MOVEDB
            CMPI    #1, D6
            BEQ     MOVEAB
            CMPI    #2, D6
            BEQ     MOVEDEREGISTERAB
            CMPI    #3, D6
            BEQ     MOVEPOSTADDAB
            CMPI    #4, D6
            BEQ     MOVEPRESUBAB
            CMPI    #5, D6
            BEQ     MOVED16AB
            CMPI    #6, D6
            BEQ     MOVED8AXB
            CMPI    #7, D6
            BEQ     MOVEWLD2
            
*Check register
MOVEWLD2:
            CMPI    #0, D7
            BEQ     MOVEWORDB
            CMPI    #1, D7
            BEQ     MOVELONGB
            CMPI    #4, D7
            BEQ     MOVEDATAB
            
MOVEADD1:
            ADDI    #1, D3
            JMP     MOVECONTINUE1
    
MOVEADD2:
            ADDI    #1, D5
            JMP     MOVECONTINUE2
MOVEADD3:
            ADDI    #1, D6
            JMP     MOVECONTINUE3
MOVEADD4:
            ADDI    #1, D7
            JMP     MOVECONTINUE4
MOVEADD5:
            ADDI    #1, D1
            JMP     MOVECONTINUE5
    
MOVEDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5
MOVEAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5
MOVEDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5 
MOVEPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5 
MOVEPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5
MOVED16AA:
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
            JMP     MOVENEXT5
MOVED8AXA:
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
            JMP     MOVENEXT5
            
MOVEWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
MOVELOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVESINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVECONTINUE6:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVENEXT7
            JMP     MOVELOOP6
            
MOVESINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVECONTINUE6

MOVENEXT7:
            MOVE    #4, D4
MOVELOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVENEXT8
            JMP     MOVELOOP7
MOVENEXT8:            
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5
            
MOVELONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
MOVELOOP8:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVESINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVECONTINUE7:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MOVENEXT9
            JMP     MOVELOOP8
            
MOVESINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVECONTINUE7

MOVENEXT9:
            MOVE    #8, D4
MOVELOOP9:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVENEXT10
            JMP     MOVELOOP9
MOVENEXT10:            
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5

            
MOVEDATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     MOVEWORDA
            CMPI    #2, D1
            BEQ     MOVELONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
MOVEBYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVESINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVENEXT11
            JMP     MOVEBYTELOOP1
            
MOVESINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEBYTECONTINUE1

MOVENEXT11:
            MOVE    #2, D4
MOVEBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEBYTENEXT1
            JMP     MOVEBYTELOOP2
            
MOVEBYTENEXT1:
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5
            
MOVEDB:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     FINISH
MOVEAB:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     FINISH
MOVEDEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH 
MOVEPOSTADDAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     FINISH 
MOVEPRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
MOVED16AB:
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
MOVED8AXB:
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
            
MOVEWORDB:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
MOVELOOP10:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVESINGLEDGT4
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVECONTINUE9:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVENEXT12
            JMP     MOVELOOP10
            
MOVESINGLEDGT4:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVECONTINUE6

MOVENEXT12:
            MOVE    #4, D4
MOVELOOP11:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVENEXT13
            JMP     MOVELOOP11
MOVENEXT13:            
            JMP     FINISH
            
MOVELONGB:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
MOVELOOP12:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVESINGLEDGT5
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVECONTINUE10: 
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MOVENEXT14
            JMP     MOVELOOP12
            
MOVESINGLEDGT5:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVECONTINUE10

MOVENEXT14:
            MOVE    #8, D4
MOVELOOP13:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVENEXT15
            JMP     MOVELOOP13
MOVENEXT15:            
            JMP     FINISH

            
MOVEDATAB:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     MOVEWORDA
            CMPI    #2, D1
            BEQ     MOVELONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
MOVEBYTELOOP3:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVESINGLEDGT6
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEBYTECONTINUE2:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVENEXT16
            JMP     MOVEBYTELOOP3
            
MOVESINGLEDGT6:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEBYTECONTINUE2

MOVENEXT16:
            MOVE    #2, D4
MOVEBYTELOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEBYTENEXT2
            JMP     MOVEBYTELOOP4
MOVEBYTENEXT2:
            JMP     FINISH
           
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
