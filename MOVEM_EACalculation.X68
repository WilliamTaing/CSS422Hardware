*Also works for JSR and memory shifts for ASL, ASR, LSL, LSR, ROL, ROR
    ORG    $1000
START:                 
*Get first three bits (EA register)
            MOVEM   $20, D1
            MOVEA   A1, A2
            MOVE    #3, D4
            MOVEA   #$1002, A4
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
    
*Get next three bits (EA mode)
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
NEXT2:
*Skip next four bits
            ROL     #3, D5
            LSR     #4, D2
            
*Get next bit (dr)
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADD3
CONTINUE3:

*Check dr
            MOVE    (A4)+, D6
            CMPI    #1, D7
            BEQ     MEMTOREG
            JMP     REGTOMEM
                    
MEMTOREG:
            CMPI    #2, D5
            BEQ     DEREGISTERAA
            CMPI    #3, D5
            BEQ     POSTADDAA
            CMPI    #5, D5
            BEQ     D16AA
            CMPI    #6, D5
            BEQ     D8AXA
            CMPI    #7, D5
            BEQ     WLD1
CONTINUE4:
*Print out registers
            LSR     #1, D6
            BCS     MEM1
BACK1:      LSR     #1, D6
            BCS     MEM2
BACK2:      LSR     #1, D6
            BCS     MEM3
BACK3:      LSR     #1, D6
            BCS     MEM4
BACK4:      LSR     #1, D6
            BCS     MEM5
BACK5:      LSR     #1, D6
            BCS     MEM6
BACK6:      LSR     #1, D6
            BCS     MEM7
BACK7:      LSR     #1, D6
            BCS     MEM8
BACK8:      LSR     #1, D6
            BCS     MEM9
BACK9:      LSR     #1, D6
            BCS     MEM10
BACK10:     LSR     #1, D6
            BCS     MEM11
BACK11:     LSR     #1, D6
            BCS     MEM12
BACK12:     LSR     #1, D6
            BCS     MEM13
BACK13:     LSR     #1, D6
            BCS     MEM14
BACK14:     LSR     #1, D6
            BCS     MEM15
BACK15:     LSR     #1, D6
            BCS     MEM16
BACK16:
            JMP     FINISH
            
REGTOMEM:
*Print out registers
            CMPI    #4, D5
            BEQ     REVERSEMEM
            LSR     #1, D6
            BCS     MEM17
BACK17:     LSR     #1, D6
            BCS     MEM18
BACK18:     LSR     #1, D6
            BCS     MEM19
BACK19:     LSR     #1, D6
            BCS     MEM20
BACK20:     LSR     #1, D6
            BCS     MEM21
BACK21:     LSR     #1, D6
            BCS     MEM22
BACK22:     LSR     #1, D6
            BCS     MEM23
BACK23:     LSR     #1, D6
            BCS     MEM24
BACK24:     LSR     #1, D6
            BCS     MEM25
BACK25:     LSR     #1, D6
            BCS     MEM26
BACK26:     LSR     #1, D6
            BCS     MEM27
BACK27:     LSR     #1, D6
            BCS     MEM28
BACK28:     LSR     #1, D6
            BCS     MEM29
BACK29:     LSR     #1, D6
            BCS     MEM30
BACK30:     LSR     #1, D6
            BCS     MEM31
BACK31:     LSR     #1, D6
            BCS     MEM32
BACK32:
            JMP     CONTINUE5
          
REVERSEMEM:     
            LSR     #1, D6
            BCS     MEM33
BACK33:     LSR     #1, D6
            BCS     MEM34
BACK34:     LSR     #1, D6
            BCS     MEM35
BACK35:     LSR     #1, D6
            BCS     MEM36
BACK36:     LSR     #1, D6
            BCS     MEM37
BACK37:     LSR     #1, D6
            BCS     MEM38
BACK38:     LSR     #1, D6
            BCS     MEM39
BACK39:     LSR     #1, D6
            BCS     MEM40
BACK40:     LSR     #1, D6
            BCS     MEM41
BACK41:     LSR     #1, D6
            BCS     MEM42
BACK42:     LSR     #1, D6
            BCS     MEM43
BACK43:     LSR     #1, D6
            BCS     MEM44
BACK44:     LSR     #1, D6
            BCS     MEM45
BACK45:     LSR     #1, D6
            BCS     MEM46
BACK46:     LSR     #1, D6
            BCS     MEM47
BACK47:     LSR     #1, D6
            BCS     MEM48
            
CONTINUE5:
            CMPI    #2, D5
            BEQ     DEREGISTERAB
            CMPI    #4, D5
            BEQ     PRESUBAB
            CMPI    #5, D5
            BEQ     D16AB
            CMPI    #6, D5
            BEQ     D8AXB
            CMPI    #7, D5
            BEQ     WLD2
   
*Check register 
WLD1:
            CMPI    #0, D3
            BEQ     WORDA
            CMPI    #1, D3
            BEQ     LONGA
            
WLD2:
            CMPI    #0, D3
            BEQ     WORDB
            CMPI    #1, D3
            BEQ     LONGB
            
ADD1:
            ADDI    #1, D3
            JMP     CONTINUE1
    
ADD2:
            ADDI    #1, D5
            JMP     CONTINUE2
ADD3:
            ADDI    #1, D7
            JMP     CONTINUE3
    
DEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     CONTINUE4 
POSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     CONTINUE4 
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
            JMP     CONTINUE4
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
            JMP     CONTINUE4
            
WORDA:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
LOOP3:
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
            BEQ     NEXT3
            JMP     LOOP3
            
SINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE6

NEXT3:
            MOVE    #4, D4
LOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT4
            JMP     LOOP4
NEXT4:            
            MOVE.B  #' ', (A2)+
            JMP     CONTINUE4
            
LONGA:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
LOOP5:
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
            BEQ     NEXT5
            JMP     LOOP5
            
SINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE7

NEXT5:
            MOVE    #8, D4
LOOP6:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT6
            JMP     LOOP6
NEXT6:            
            MOVE.B  #' ', (A2)+
            JMP     CONTINUE4
            
DEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
PRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     FINISH
D16AB:
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
D8AXB:
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
            
WORDB:
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
LOOP7:
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
            BEQ     NEXT7
            JMP     LOOP7
            
SINGLEDGT4:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE6

NEXT7:
            MOVE    #4, D4
LOOP8:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT8
            JMP     LOOP8
NEXT8:            
            JMP     FINISH
            
LONGB:
            MOVE.B  #'$', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
LOOP9:
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
            BEQ     NEXT9
            JMP     LOOP9
            
SINGLEDGT5:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     CONTINUE10

NEXT9:
            MOVE    #8, D4
LOOP10:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     NEXT10
            JMP     LOOP10
NEXT10:            
            JMP     FINISH

            
MEM1:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK1
            
MEM2:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK2
            
MEM3:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK3

MEM4:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK3

MEM5:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK5

MEM6:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK6

MEM7:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK7

MEM8:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK8

MEM9:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK9

MEM10:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK10
            
MEM11:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK11

MEM12:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK12
           
MEM13:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK13
            
MEM14:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK14
            
MEM15:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK15
MEM16:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'7', (A2)+
            JMP     BACK16         

MEM17:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK17
            
MEM18:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK18
            
MEM19:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK19

MEM20:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK20

MEM21:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK21

MEM22:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK22

MEM23:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK23

MEM24:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK24

MEM25:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK25

MEM26:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK26
            
MEM27:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK27

MEM28:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK28
           
MEM29:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK29
            
MEM30:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK30
            
MEM31:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK31
MEM32:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK32
            
MEM33:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK33
            
MEM34:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK34
            
MEM35:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK35

MEM36:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK36

MEM37:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK37

MEM38:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK38

MEM39:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK39

MEM40:
            MOVE.B  #'A', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK40

MEM41:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'7', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK41

MEM42:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK42
            
MEM43:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'5', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK43

MEM44:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'4', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK44
           
MEM45:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'3', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK45
            
MEM46:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'2', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK46
            
MEM47:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     BACK47
MEM48:
            MOVE.B  #'D', (A2)+
            MOVE.B  #'0', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     CONTINUE5
            

FINISH:     SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
