    ORG    $1000
START:                 
*Get first three bits (EA register)
            MOVEM   $20, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1002, A4
            MOVEA   #$1000, A0
            MOVE    (A0), D2
MOVEMLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEMADD1
MOVEMCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEMNEXT1
            JMP     MOVEMLOOP1
    
*Get next three bits (EA mode)
MOVEMNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
MOVEMLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEMADD2
MOVEMCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEMNEXT2
            JMP     MOVEMLOOP2
MOVEMNEXT2:
*Skip next four bits
            ROL     #3, D5
            LSR     #4, D2
            
*Get next bit (dr)
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEMADD3
MOVEMCONTINUE3:

*Check dr
            MOVE    (A4)+, D6
            CMPI    #1, D7
            BEQ     MOVEMMEMTOREG
            JMP     MOVEMREGTOMEM
                    
MOVEMMEMTOREG:
            CMPI    #2, D5
            BEQ     MOVEMDEREGISTERAA
            CMPI    #3, D5
            BEQ     MOVEMPOSTADDAA
            CMPI    #5, D5
            BEQ     MOVEMD16AA
            CMPI    #6, D5
            BEQ     MOVEMD8AXA
            CMPI    #7, D5
            BEQ     MOVEMWLD1
MOVEMCONTINUE4:
*Print out registers
            LSR     #1, D6
            BCS     MOVEMMEM1
MOVEMBACK1: 
            LSR     #1, D6
            BCS     MOVEMMEM2
MOVEMBACK2:      
            LSR     #1, D6
            BCS     MOVEMMEM3
MOVEMBACK3:      
            LSR     #1, D6
            BCS     MOVEMMEM4
MOVEMBACK4:      
            LSR     #1, D6
            BCS     MOVEMMEM5
MOVEMBACK5:      
            LSR     #1, D6
            BCS     MOVEMMEM6
MOVEMBACK6:      
            LSR     #1, D6
            BCS     MOVEMMEM7
MOVEMBACK7:      
            LSR     #1, D6
            BCS     MOVEMMEM8
MOVEMBACK8:      
            LSR     #1, D6
            BCS     MOVEMMEM9
MOVEMBACK9:      
            LSR     #1, D6
            BCS     MOVEMMEM10
MOVEMBACK10:     
            LSR     #1, D6
            BCS     MOVEMMEM11
MOVEMBACK11:     
            LSR     #1, D6
            BCS     MOVEMMEM12
MOVEMBACK12:     
            LSR     #1, D6
            BCS     MOVEMMEM13
MOVEMBACK13:     
            LSR     #1, D6
            BCS     MOVEMMEM14
MOVEMBACK14:     
            LSR     #1, D6
            BCS     MOVEMMEM15
MOVEMBACK15:     
            LSR     #1, D6
            BCS     MOVEMMEM16
MOVEMBACK16:
            JMP     FINISH
            
MOVEMREGTOMEM:
*Print out registers
            CMPI    #4, D5
            BEQ     MOVEMREVERSEMEM
            LSR     #1, D6
            BCS     MOVEMMEM17
MOVEMBACK17:     
            LSR     #1, D6
            BCS     MOVEMMEM18
MOVEMBACK18:     
            LSR     #1, D6
            BCS     MOVEMMEM19
MOVEMBACK19:     
            LSR     #1, D6
            BCS     MOVEMMEM20
MOVEMBACK20:     
            LSR     #1, D6
            BCS     MOVEMMEM21
MOVEMBACK21:     
            LSR     #1, D6
            BCS     MOVEMMEM22
MOVEMBACK22:     
            LSR     #1, D6
            BCS     MOVEMMEM23
MOVEMBACK23:     
            LSR     #1, D6
            BCS     MOVEMMEM24
MOVEMBACK24:     
            LSR     #1, D6
            BCS     MOVEMMEM25
MOVEMBACK25:     
            LSR     #1, D6
            BCS     MOVEMMEM26
MOVEMBACK26:     
            LSR     #1, D6
            BCS     MOVEMMEM27
MOVEMBACK27:     
            LSR     #1, D6
            BCS     MOVEMMEM28
MOVEMBACK28:     
            LSR     #1, D6
            BCS     MOVEMMEM29
MOVEMBACK29:     
            LSR     #1, D6
            BCS     MOVEMMEM30
MOVEMBACK30:     
            LSR     #1, D6
            BCS     MOVEMMEM31
MOVEMBACK31:     
            LSR     #1, D6
            BCS     MOVEMMEM32
MOVEMBACK32:
            JMP     MOVEMCONTINUE5
          
MOVEMREVERSEMEM:     
            LSR     #1, D6
            BCS     MOVEMMEM33
MOVEMBACK33:     
            LSR     #1, D6
            BCS     MOVEMMEM34
MOVEMBACK34:     
            LSR     #1, D6
            BCS     MOVEMMEM35
MOVEMBACK35:     
            LSR     #1, D6
            BCS     MOVEMMEM36
MOVEMBACK36:     
            LSR     #1, D6
            BCS     MOVEMMEM37
MOVEMBACK37:     
            LSR     #1, D6
            BCS     MOVEMMEM38
MOVEMBACK38:     
            LSR     #1, D6
            BCS     MOVEMMEM39
MOVEMBACK39:     
            LSR     #1, D6
            BCS     MOVEMMEM40
MOVEMBACK40:     
            LSR     #1, D6
            BCS     MOVEMMEM41
MOVEMBACK41:     
            LSR     #1, D6
            BCS     MOVEMMEM42
MOVEMBACK42:     
            LSR     #1, D6
            BCS     MOVEMMEM43
MOVEMBACK43:     
            LSR     #1, D6
            BCS     MOVEMMEM44
MOVEMBACK44:     
            LSR     #1, D6
            BCS     MOVEMMEM45
MOVEMBACK45:     
            LSR     #1, D6
            BCS     MOVEMMEM46
MOVEMBACK46:     
            LSR     #1, D6
            BCS     MOVEMMEM47
MOVEMBACK47:     
            LSR     #1, D6
            BCS     MOVEMMEM48
            
MOVEMCONTINUE5:
            CMPI    #2, D5
            BEQ     MOVEMDEREGISTERAB
            CMPI    #4, D5
            BEQ     MOVEMPRESUBAB
            CMPI    #5, D5
            BEQ     MOVEMD16AB
            CMPI    #6, D5
            BEQ     MOVEMD8AXB
            CMPI    #7, D5
            BEQ     MOVEMWLD2
   
*Check register 
MOVEMWLD1:
            CMPI    #0, D3
            BEQ     MOVEMWORDA
            CMPI    #1, D3
            BEQ     MOVEMLONGA
            
MOVEMWLD2:
            CMPI    #0, D3
            BEQ     MOVEMWORDB
            CMPI    #1, D3
            BEQ     MOVEMLONGB
            
MOVEMADD1:
            ADDI    #1, D3
            JMP     MOVEMCONTINUE1
    
MOVEMADD2:
            ADDI    #1, D5
            JMP     MOVEMCONTINUE2
MOVEMADD3:
            ADDI    #1, D7
            JMP     MOVEMCONTINUE3
    
MOVEMDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMCONTINUE4 
MOVEMPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMCONTINUE4 
MOVEMD16AA:
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
            JMP     MOVEMCONTINUE4
MOVEMD8AXA:
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
            JMP     MOVEMCONTINUE4
            
MOVEMWORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
MOVEMLOOP3:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEMSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEMCONTINUE6:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVEMNEXT3
            JMP     MOVEMLOOP3
            
MOVEMSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEMCONTINUE6

MOVEMNEXT3:
            MOVE    #4, D4
MOVEMLOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEMNEXT4
            JMP     MOVEMLOOP4
MOVEMNEXT4:            
            MOVE.B  #' ', (A2)+
            JMP     MOVEMCONTINUE4
            
MOVEMLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
MOVEMLOOP5:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEMSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEMCONTINUE7:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MOVEMNEXT5
            JMP     MOVEMLOOP5
            
MOVEMSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEMCONTINUE7

MOVEMNEXT5:
            MOVE    #8, D4
MOVEMLOOP6:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEMNEXT6
            JMP     MOVEMLOOP6
MOVEMNEXT6:            
            MOVE.B  #' ', (A2)+
            JMP     MOVEMCONTINUE4
            
MOVEMDEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
MOVEMPRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
MOVEMD16AB:
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
MOVEMD8AXB:
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
            
MOVEMWORDB:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
MOVEMLOOP7:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEMSINGLEDGT4
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEMCONTINUE9:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVEMNEXT7
            JMP     MOVEMLOOP7
            
MOVEMSINGLEDGT4:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEMCONTINUE6

MOVEMNEXT7:
            MOVE    #4, D4
MOVEMLOOP8:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEMNEXT8
            JMP     MOVEMLOOP8
MOVEMNEXT8:            
            JMP     FINISH
            
MOVEMLONGB:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
MOVEMLOOP9:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEMSINGLEDGT5
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEMCONTINUE10: 
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MOVEMNEXT9
            JMP     MOVEMLOOP9
            
MOVEMSINGLEDGT5:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEMCONTINUE10

MOVEMNEXT9:
            MOVE    #8, D4
MOVEMLOOP10:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEMNEXT10
            JMP     MOVEMLOOP10
MOVEMNEXT10:            
            JMP     FINISH

            
MOVEMMEM1:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK1
            
MOVEMMEM2:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK2
            
MOVEMMEM3:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK3

MOVEMMEM4:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK3

MOVEMMEM5:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK5

MOVEMMEM6:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK6

MOVEMMEM7:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK7

MOVEMMEM8:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK8

MOVEMMEM9:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK9

MOVEMMEM10:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK10
            
MOVEMMEM11:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK11

MOVEMMEM12:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK12
           
MOVEMMEM13:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK13
            
MOVEMMEM14:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK14
            
MOVEMMEM15:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK15
MOVEMMEM16:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'7', (A2)+
            JMP     MOVEMBACK16         

MOVEMMEM17:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK17
            
MOVEMMEM18:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK18
            
MOVEMMEM19:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK19

MOVEMMEM20:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK20

MOVEMMEM21:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK21

MOVEMMEM22:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK22

MOVEMMEM23:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK23

MOVEMMEM24:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK24

MOVEMMEM25:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK25

MOVEMMEM26:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK26
            
MOVEMMEM27:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK27

MOVEMMEM28:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK28
           
MOVEMMEM29:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK29
            
MOVEMMEM30:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK30
            
MOVEMMEM31:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK31
MOVEMMEM32:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK32
            
MOVEMMEM33:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK33
            
MOVEMMEM34:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK34
            
MOVEMMEM35:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK35

MOVEMMEM36:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK36

MOVEMMEM37:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK37

MOVEMMEM38:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK38

MOVEMMEM39:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK39

MOVEMMEM40:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK40

MOVEMMEM41:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK41

MOVEMMEM42:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK42
            
MOVEMMEM43:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK43

MOVEMMEM44:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK44
           
MOVEMMEM45:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK45
            
MOVEMMEM46:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK46
            
MOVEMMEM47:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMBACK47
MOVEMMEM48:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMCONTINUE5
            
FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
