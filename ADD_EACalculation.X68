*Also works for OR, AND, and SUB
    ORG    $1000
START:                 
*Get first three bits (source register)
            ADD.B   D0, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
ADDLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDADD1
ADDCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDNEXT1
            JMP     ADDLOOP1
    
*Get next three bits (source mode)
ADDNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
ADDLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDADD2
ADDCONTINUE2:
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDNEXT2
            JMP     ADDLOOP2
            
*Get next three bits (opmode)   
ADDNEXT2:
            ROL     #3, D5
            MOVE    #3, D4
ADDLOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDADD3
ADDCONTINUE3:
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDNEXT3
            JMP     ADDLOOP3
            
*Get next three bits (destination register)
ADDNEXT3:
            ROL     #3, D6
            MOVE    #3, D4
ADDLOOP4:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDADD4
ADDCONTINUE4:
            ROR     #1, D7
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDNEXT4
            JMP     ADDLOOP4

*Figure out which is source and which is destination via opcode
ADDNEXT4:
            ROL     #3, D7
            MOVE    #1, D1  ;Is it a byte?
            CMPI    #0, D6
            JMP     ADDNEXT5
            MOVE    #3, D1  ;Is it a word?
            CMPI    #1, D6
            JMP     ADDNEXT5
            MOVE    #2, D1  ;Is it a long?
            CMPI    #2, D6
            JMP     ADDNEXT5
            MOVE    #1, D1  ;Is it a byte?
            CMPI    #4, D6
            JMP     ADDNEXT6
            MOVE    #3, D1  ;Is it a word?
            CMPI    #5, D6
            JMP     ADDNEXT6
            MOVE    #2, D1  ;Is it a long?
            CMPI    #6, D6
            JMP     ADDNEXT6
            

ADDNEXT5:   ;If the format is <ea>, Dn -> Dn
            CMPI    #0, D5
            BEQ     ADDDA
            CMPI    #1, D5
            BEQ     ADDAA
            CMPI    #2, D5
            BEQ     ADDDEREGISTERAA
            CMPI    #3, D5
            BEQ     ADDPOSTADDAA
            CMPI    #4, D5
            BEQ     ADDPRESUBAA
            CMPI    #5, D5
            BEQ     ADDD16AA
            CMPI    #6, D5
            BEQ     ADDD8AXA
            CMPI    #7, D5
            BEQ     ADDWLD1
ADDCONTINUE5:
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     FINISH
            
ADDNEXT6:   ;If the format is Dn, <ea> -> <ea>
            MOVE.B  #'D', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #' ', (A2)+
            CMPI    #0, D5
            BEQ     ADDDB
            CMPI    #1, D5
            BEQ     ADDAB
            CMPI    #2, D5
            BEQ     ADDDEREGISTERAB
            CMPI    #3, D5
            BEQ     ADDPOSTADDAB
            CMPI    #4, D5
            BEQ     ADDPRESUBAB
            CMPI    #5, D5
            BEQ     ADDD16AB
            CMPI    #6, D5
            BEQ     ADDD8AXB
            CMPI    #7, D5
            BEQ     ADDWLD2

*Check register            
ADDWLD1:
            CMPI    #0, D3
            BEQ     ADDWORDA
            CMPI    #1, D3
            BEQ     ADDLONGA
            CMPI    #4, D3
            BEQ     ADDDATAA

ADDWLD2:
            CMPI    #0, D7
            BEQ     ADDWORDB
            CMPI    #1, D7
            BEQ     ADDLONGB
            CMPI    #4, D7
            BEQ     ADDDATAB
            
ADDADD1:
            ADDI    #1, D3
            JMP     ADDCONTINUE1
    
ADDADD2:
            ADDI    #1, D5
            JMP     ADDCONTINUE2
ADDADD3:
            ADDI    #1, D6
            JMP     ADDCONTINUE3
ADDADD4:
            ADDI    #1, D7
            JMP     ADDCONTINUE4
    
ADDDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     ADDCONTINUE5
ADDAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     ADDCONTINUE5
ADDDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ADDCONTINUE5
ADDPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     ADDCONTINUE5
ADDPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ADDCONTINUE5
ADDD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ADDCONTINUE5
ADDD8AXA:
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
            JMP     ADDCONTINUE5
            
ADDWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ADDLOOP5:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDCONTINUE6:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDNEXT7
            JMP     ADDLOOP5
            
ADDSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDCONTINUE6

ADDNEXT7:
            MOVE    #4, D4
ADDLOOP6:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDNEXT8
            JMP     ADDLOOP6
ADDNEXT8:            
            MOVE.B  #' ', (A2)+
            JMP     ADDNEXT5
            
ADDLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ADDLOOP7:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDCONTINUE7:
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ADDNEXT9
            JMP     ADDLOOP7
            
ADDSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDCONTINUE7

ADDNEXT9:
            MOVE    #8, D4
ADDLOOP8:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDNEXT10
            JMP     ADDLOOP8
ADDNEXT10:            
            MOVE.B  #' ', (A2)+
            JMP     ADDNEXT5

            
ADDDATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     ADDWORDA
            CMPI    #2, D1
            BEQ     ADDLONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
ADDBYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDSINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDNEXT11
            JMP     ADDBYTELOOP1
            
ADDSINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDBYTECONTINUE1

ADDNEXT11:
            MOVE    #2, D4
ADDBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDBYTENEXT1
            JMP     ADDBYTELOOP2
            
ADDBYTENEXT1:
            MOVE.B  #' ', (A2)+
            JMP     ADDNEXT5


            
ADDDB:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH
ADDAB:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     FINISH
ADDDEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH 
ADDPOSTADDAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     FINISH 
ADDPRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
ADDD16AB:
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
ADDD8AXB:
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
                        
ADDWORDB:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ADDLOOP9:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDSINGLEDGT4
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDCONTINUE9:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDNEXT12
            JMP     ADDLOOP9
            
ADDSINGLEDGT4:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDCONTINUE6

ADDNEXT12:
            MOVE    #4, D4
ADDLOOP10:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDNEXT13
            JMP     ADDLOOP10
ADDNEXT13:            
            JMP     FINISH
            
ADDLONGB:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ADDLOOP11:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDSINGLEDGT5
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDCONTINUE10:
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ADDNEXT14
            JMP     ADDLOOP11
            
ADDSINGLEDGT5:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDCONTINUE10

ADDNEXT14:
            MOVE    #8, D4
ADDLOOP12:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDNEXT14
            JMP     ADDLOOP12
ADDEXT15:            
            JMP     FINISH

            
ADDDATAB:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     ADDWORDA
            CMPI    #2, D1
            BEQ     ADDLONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
ADDBYTELOOP3:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDSINGLEDGT6
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDBYTECONTINUE2:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDNEXT16
            JMP     ADDBYTELOOP3
            
ADDSINGLEDGT6:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDBYTECONTINUE2

ADDNEXT16:
            MOVE    #2, D4
ADDBYTELOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDBYTENEXT2
            JMP     ADDBYTELOOP4
ADDBYTENEXT2:
            JMP     FINISH

            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
