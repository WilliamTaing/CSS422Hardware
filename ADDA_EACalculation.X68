    ORG    $1000
START:                 
*Get first three bits (source register)
            ADD.B   D0, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
ADDALOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDAADD1
ADDACONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDANEXT1
            JMP     ADDALOOP1
    
*Get next three bits (source mode)
ADDANEXT1:
            ROL     #3, D3
            MOVE    #3, D4
ADDALOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDAADD2
ADDACONTINUE2:
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDANEXT2
            JMP     ADDALOOP2
            
            
*Get next three bits (opmode) 
ADDANEXT2:
            ROL     #3, D5
            MOVE    #3, D4
ADDAOPLOOP:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDAADD2
ADDAOPCONTINUE:
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDAOPNEXT
            JMP     ADDAOPLOOP

ADDAOPNEXT:
*Get next three bits (destination register)
            MOVE    #3, D4
ADDALOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDAADD3
ADDACONTINUE3:
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDANEXT3
            JMP     ADDALOOP3
            
*Print address
ADDANEXT3:    
            CMPI    #0, D5
            BEQ     ADDADA
            CMPI    #1, D5
            BEQ     ADDAAA
            CMPI    #2, D5
            BEQ     ADDADEREGISTERAA
            CMPI    #3, D5
            BEQ     ADDAPOSTADDAA
            CMPI    #4, D5
            BEQ     ADDAPRESUBAA
            CMPI    #5, D5
            BEQ     ADDAD16AA
            CMPI    #6, D5
            BEQ     ADDAD8AXA
            CMPI    #7, D5
            BEQ     ADDAWLD1
ADDACONTINUE5:
            MOVE.B  #' ', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            JMP     FINISH
            
ADDAWLD1:
            CMPI    #0, D3
            BEQ     ADDAWORDA
            CMPI    #1, D3
            BEQ     ADDALONGA
            CMPI    #4, D3
            BEQ     ADDADATAA
            
ADDAADD1:
            ADDI    #1, D3
            JMP     ADDACONTINUE1
    
ADDAADD2:
            ADDI    #1, D5
            JMP     ADDACONTINUE2
ADDAADD3:
            ADDI    #1, D6
            JMP     ADDACONTINUE3
ADDAADD4:
            ADDI    #1, D1
            JMP     ADDAOPCONTINUE
    
ADDADA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     ADDACONTINUE5
ADDAAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     ADDACONTINUE5
ADDADEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ADDACONTINUE5
ADDAPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     ADDACONTINUE5
ADDAPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ADDACONTINUE5
ADDAD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ADDACONTINUE5
ADDAD8AXA:
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
            JMP     ADDACONTINUE5
                   
ADDAWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ADDALOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDASINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDACONTINUE6:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDANEXT4
            JMP     ADDALOOP4
            
ADDASINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDACONTINUE6

ADDANEXT4:
            MOVE    #4, D4
ADDALOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDANEXT5
            JMP     ADDALOOP5
ADDANEXT5:            
            MOVE.B  #' ', (A2)+
            JMP     ADDACONTINUE5
            
ADDALONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ADDALOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDASINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDACONTINUE7:
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ADDANEXT6
            JMP     ADDALOOP6
            
ADDASINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDACONTINUE7

ADDANEXT6:
            MOVE    #8, D4
ADDALOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDANEXT7
            JMP     ADDALOOP7
ADDANEXT7:            
            MOVE.B  #' ', (A2)+
            JMP     ADDACONTINUE5
           
ADDADATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #3, D1
            BEQ     ADDAWORDA
            CMPI    #7, D1
            BEQ     ADDALONGA
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
