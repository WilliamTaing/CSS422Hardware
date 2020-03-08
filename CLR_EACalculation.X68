*Also works for JSR
    ORG    $1000
START:                 
*Get first three bits (register)
            MOVE    D4, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
CLRLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     CLRADD1
CLRCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     CLRNEXT1
            JMP     CLRLOOP1
    
*Get next three bits (mode)
CLRNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
CLRLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     CLRADD2
CLRCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     CLRNEXT2
            JMP     CLRLOOP2
      
*Get next two bits (size)      
CLRNEXT2:
            ROL     #3, D5
            MOVE    #2, D4
CLRLOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     CLRADD3
CLRCONTINUE3:  
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     CLRNEXT3
            JMP     CLRLOOP2

*Print out EA
CLRNEXT3:
            CMPI    #0, D5
            BEQ     CLRDA
            CMPI    #1, D5
            BEQ     CLRAA
            CMPI    #2, D5
            BEQ     CLRDEREGISTERAA
            CMPI    #3, D5
            BEQ     CLRPOSTADDAA
            CMPI    #4, D5
            BEQ     CLRPRESUBAA
            CMPI    #5, D5
            BEQ     CLRD16AA
            CMPI    #6, D5
            BEQ     CLRD8AXA
            CMPI    #7, D5
            BEQ     CLRWLD1

CLRWLD1:
            CMPI    #0, D3
            BEQ     CLRWORDA
            CMPI    #1, D3
            BEQ     CLRLONGA
            CMPI    #4, D3
            BEQ     CLRDATAA
            
CLRADD1:
            ADDI    #1, D3
            JMP     CLRCONTINUE1
    
CLRADD2:
            ADDI    #1, D5
            JMP     CLRCONTINUE2
CLRADD3:
            ADDI    #1, D6
            JMP     CLRCONTINUE3
    
CLRDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
CLRAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
CLRDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH 
CLRPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH 
CLRPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     FINISH
CLRD16AA:
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
CLRD8AXA:
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
            
CLRWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
CLRLOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     CLRSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CLRCONTINUE4:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     CLRNEXT4
            JMP     CLRLOOP4
            
CLRSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CLRCONTINUE4

CLRNEXT4:
            MOVE    #4, D4
CLRLOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     FINISH
            JMP     CLRLOOP5
            
CLRLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
CLRLOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     CLRSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CLRCONTINUE5:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     CLRNEXT5
            JMP     CLRLOOP6
            
CLRSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CLRCONTINUE5

CLRNEXT5:
            MOVE    #8, D4
CLRLOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     FINISH
            JMP     CLRLOOP7
            
CLRDATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     CLRWORDA
            CMPI    #2, D1
            BEQ     CLRLONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
CLRBYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     CLRSINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
CLRBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     CLRNEXT6
            JMP     CLRBYTELOOP1
            
CLRSINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CLRBYTECONTINUE1

CLRNEXT6:
            MOVE    #2, D4
CLRBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     CLRBYTENEXT1
            JMP     CLRBYTELOOP2
            
CLRBYTENEXT1:
            MOVE.B  #' ', (A2)+
            JMP     CLRNEXT5
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
