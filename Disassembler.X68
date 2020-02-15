*-----------------------------------------------------------
* Title      :CSS422 Disassembler
* Written by :William T and Ben F
* Date       :February 14, 2020
* Description:Final Prjoect for CSS422
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    LEA     GREETING, A1    ;Loads GREETING into A1
    MOVE.B  #14, D0         ;loads the number 14 into data register D0
    TRAP    #15
    
    LEA     PROMPT, A1      ;Prompts user to insert
    MOVE.B  #14, D0         ;loads the number 14 into data register D0
    TRAP    #15
    
    MOVE.B  #9, D0          ;loads the number 14 into data register D0
    TRAP    #15
    
* TODO


code0100:
    MOVE.W  #example, D0
    ANDI.W  #%0000111100000000, D0
    MOVE.B  #8, D1              
    LSR.W   D1, D0              ;extract 2nd nibble in D0
    MULU    #6, D0              ;compute the op_0100_table entry
    LEA     op_0100_table, A0    
    JMP     0 (A0, D0)          ;jump to op_0100 table entry
op_0100_table:
    JMP     OP_UNSUPPORTED      ;0: MOVE from SR not supported
    JMP     OP_LEA              ;1: LEA An 1
    JMP     OP_CLR              ;2: CLR
    JMP     OP_LEA              ;3: LEA An 1
    JMP     OP_UNSUPPORTED       ;4: MOVE from CCR not supported
    JMP     OP_LEA              ;5: LEA An 1
    JMP     OP_NOT              ;6: NOT
    JMP     OP_LEA              ;7: LEA An 1
    JMP     OP_EXT_MOVEM        ;8: EXT, MOVEM
    JMP     OP_LEA              ;9: LEA An 1
    JMP     OP_UNSUPPORTED      ;A: ILLEGAL, TAS, TST not supported
    JMP     OP_LEA              ;B: LEA An 1
    JMP     OP_MOVEM            ;C: MOVEM
    JMP     OP_LEA              ;D: LEA An 1
    JMP     OP_JNRST            ;E: JMP, JSR, NOP, RTE, RTS, STOP, TRAP,
    JMP     OP_LEA              :F: LEA An 1

OP_CLR:
    MOVE.B  #'C', (An)+
    MOVE.B  #'L', (An)+
    MOVE.B  #'R', (An)+
    MOVE.L  #ea_type_clear, D1  ;D1 distinguishes EA calculation
    JSR     EA_START            ;call the EA calculation routine
    JMP     OP_FINISH 
OP_MOVE:
    MOVE.B  #'M', (An)+
    MOVE.B  #'O', (An)+
    MOVE.B  #'V', (An)+
    MOVE.B  #'E', (An)+
    MOVE.L  #ea_type_move, D1   ;D1 distinguishes EA calculation
    JSR     EA_START            ;call the EA calculation routine
    JMP     OP_FINISH
OP_LEA:
    MOVE.B  #'L', (An)+
    MOVE.B  #'E', (An)+
    MOVE.B  #'A', (An)+
    MOVE.L  #ea_type_lea, D1    ;D1 distinguishes EA calculation
    JSR     EA_START            ;call the EA calculation routine
    JMP     OP_FINISH
OP_NOT:
    MOVE.B  #'N', (An)+
    MOVE.B  #'O', (An)+
    MOVE.B  #'T', (An)+
    MOVE.L  #ea_type_not, D1    ;D1 distinguishes EA calculation
    JSR     EA_START            ;call the EA calculation routine
    JMP     OP_FINISH
OP_EXT_MOVEM:
    *TODO
OP_MOVEM:
    MOVE.B  #'M', (An)+
    MOVE.B  #'O', (An)+
    MOVE.B  #'V', (An)+
    MOVE.B  #'E', (An)+
    MOVE.B  #'M', (An)+
    MOVE.L  #ea_type_movem, D1  ;D1 distinguishes EA calculation
    JSR     EA_START            ;call the EA calculation routine
    JMP     OP_FINISH
OP_JRNST:
    *TODO
OP_UNSUPPORTED:
    *TODO

EA_START:
    LEA     EA_TYPE_TABLE, A0
    MULU    #6, D1
    JMP     0 (A0, D1)          ;jump to each EA handling table entry
EA_FINISH:
    *TODO
    RTS
EA_TYPE_TABLE:
    JMP     EA_IMMEDIATE        ;0: ea_immediate
    JMP     EA_MOVE             ;1: ea_move
    JMP     EA_LEA              ;2: ea_lea
    JMP     EA_DSTONLY          ;3: ea_dstonly
    JMP     EA_EXT              ;4: ea_ext
    JMP     EA_TRAP             ;5: ea_trap
    JMP     EA_QUICK            ;6: ea_quick
    JMP     EA_BRANCH           ;7: ea_branch
    *...
    JMP     EA_FINISH




    SIMHALT             ; halt simulator

* Put variables and constants here
CR          EQU     $0D
LF          EQU     $0A
GREETING    DC.B    'Welcome to the Disassembler', CR, LF, 0
PROMPT      DC.B    'Please select range of code to disassemble', CR, LF, 0

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
