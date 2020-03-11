*-----------------------------------------------------------
* Title      :CSS422 Disassembler
* Written by :William T and Ben Fulton
* Date       :March 20, 2020
* Description:Final Prjoect for CSS422
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    ;TEST CODE
    MOVEA   #$FF, A1     ;TRAP/STOP/EA_AS_FUNCTIONS do not work. EOR Reversed output
    OR      D3, D5       ;For WILLIAM: JMP turns into ORI
    AND     D3, D5       ;More testing needed
    OR      #5, D5
    AND     #4, D2
    CMPI    #5, D0
    MOVE.B  #1, D5
    MOVE.B  #1, D1
    DIVU    D1, D5
    LSR     D2, D1
    ASL     D1, D2
    ASR     D5, D7
    ROL     D4, D6
    ROR     D7, D6
    OR      #1, D6
    OR      D2, D3
    ROL     #1, D0
    JSR     Q
    JMP     Q1
    MULU    #1, D3
    DIVU    #11, D3
    DIVS    #5, D3
    MULS    #6, D3
    MOVEM.W D2, $400
    ADDI.B  #15, D3
    SUBI.W  #15, D3
    ADDI.L  #18, D4
    ADDQ    #3, D3
    ADDQ    #4, D4
    ADDQ    #5, D6
    ADDQ    #3, D3
    ADDQ    #5, D6
    ADDQ    #3, D3
    ADDQ    #4, D4
    ADDQ    #5, D6
    ADDQ    #3, D3
    ADDQ    #4, D4
    ADDQ    #5, D6
    ADDQ    #3, D3
    ADDQ    #4, D4
    ADDQ    #5, D6
    ADD.B   D3, D4
Q:
    RTS
Q1:
    
    CLR.B   D7      ;TEST INSTRUCTIONS
    LEA     STACK, A7   ;stack and stack pointer (A7) at $A0000
    
    ;END TEST CODE

* Put program code here

    LEA     GREETING, A1    ;Loads GREETING into A1
    MOVE.B  #14, D0         ;loads the number 14 into data register D0
    TRAP    #15
    
FIND_ADDRESS: 
    MOVEQ   #0, D2
    MOVEQ   #0, D3
    MOVEQ   #0, D4          ;Clear Registers for use
    LEA     BUFFER, A2      ;A2 is pointing to the buffer
    
    
    LEA     PROMPT1, A1     ;Prompts user to insert start address
    MOVE.B  #14, D0         ;loads the number 14 into data register D0
    TRAP    #15
    
    MOVE.L  A1, (A7)+
    MOVEA.L A7, A1       ;Move A1 to stack so that memory is not overwritten
    MOVE.B  #2, D0
    TRAP    #15             ;Takes user input, put in (A1)
    JSR     ATOI            ;Convert ASCII to integer
    MOVEQ   #0, D1          ;Clear D1 after use in ATOI
    CMP.B   #-1, D0
    BEQ     ERROR_HANDLER   ;Go to ERROR_HANDLER if D0 = -1
    MOVE.B  #3, D1          ;Invalid input address error code
    MOVE.L  D3, D4          ;Check if valid address (Not odd address space)
    LSR     #1, D4          ;Check if odd
    BCS     ERROR_HANDLER
    MOVEA.L D3, A4          ;Stores decoded start address in A4
    MOVEQ   #0, D2
    MOVEQ   #0, D3
    MOVEQ   #0, D4          ;Clears registers D2, D3, and D4 after use in ATOI
    
    MOVEA.L -(A7), A1       ;Return A1 to normal location
    LEA     PROMPT2, A1     ;Prompts user to insert end address
    MOVE.B  #14, D0         ;Display
    TRAP    #15
    
    MOVE.L  A1, (A7)+       ;Save location of A1
    MOVEA.L A7, A1          ;Move A1 to stack so that memory is not overwritten
    MOVE.B  #2, D0          ;Get user input, put in (A1)
    Trap    #15
    JSR     ATOI            ;Convert ASCII to integer
    CMP.B   #-1, D0
    BEQ     ERROR_HANDLER   ;Go to ERROR_HANDLER if D0 = -1
    MOVE.B  #3, D1          ;Invalid input address error code
    MOVE.L  D3, D4          ;Check if valid address (Not odd address space)
    LSR     #1, D4          ;Check if odd
    BCS     ERROR_HANDLER
    MOVEA.L D3, A5          ;Stores decoded end address in A5
    MOVEQ   #0, D2
    MOVEQ   #0, D3
    MOVEQ   #0, D4          ;Clears registers D3 and D4 after use in ATOI
    MOVEA.L -(A7), A1       ;Return A1 to normal location
    
    MOVE.B  #4, D1          ;Invalid range error
    CMPA.L  A4, A5
    BLT     ERROR_HANDLER   ;If A5 is less than A4, error
    MOVE.B  #21, D5         ;Count lines printed
    BRA     PROG_READER     ;Start reading the program
    
    MOVE.B  #9, D0          ;loads the number 9 into data register D0
    TRAP    #15             ;terminates program
    BRA     END_PROG
    
    
    
    
    
    
*-----------------------------------------------------------
*ATOI: Converts and ASCII character to an integer
*A0 ASCII_TABLE
*A1 Holds String
*D1 Holds Length
*D2 Holds ASCII char to convert
*D3 Variable to hold converted integer
*D4 Counts loop
ATOI:
    MOVE.B  D1, D5             ;Move Length to D5 so D1 can store error code
    MOVE.B  #3, D1             ;2 = Address error
    CMPI.B  #0, D5
    BEQ     ERROR_HANDLER      ;No length, throw error
    CMPI.B  #9, D5
    BGT     ERROR_HANDLER      ;Too many characters
    
    
    
    MOVE.B  #0, D0
    MOVE.B  (A1)+, D2          ;Move A1 to D2
    CMPI    #36, D2            ;Checks if first symbol is $
    BNE     ERROR_HANDLER      ;If the first symbol is not $, throw error
    
STR_READ:
    ADDI    #1, D4             ;Increment D4
    CMP.B   D5, D4             ;If D4 is still smaller than D5, continue
    BGE     ATOI_DONE          ;When there are no more characters to read, finish
    MOVE.B  (A1)+, D2          ;Iterate through string
    CMPI    #48, D2
    BGE     ATOI_DECODE_NUM    ;If numbers are within range <=48 check if number or hex letter
    BRA     ERROR_HANDLER      ;If numbers are not within range (<=48) throw error

ATOI_DECODE_NUM:
    CMPI    #57, D2
    BGT     ATOI_DECODE_LETTER  ;If char is not in number range, check if its a letter   
;If char is in range, find what number it is
;(ASCII48(0) - 48 = 0) (ASCII49(1) - 48 = 1)
    SUBI    #48, D2             
    ROL.L   #4, D3              ;Make room to add a new byte in D3
    ADD.B   D2, D3              ;Add next char to D3
    BRA     STR_READ            ;Read next char
    
ATOI_DECODE_LETTER:
    CMPI    #65, D2
    BLT     ERROR_HANDLER       ;If char is less than letter range, error
    CMPI    #70, D2
    BGT     ERROR_HANDLER       ;If char is greater than letter range, error
;If char is in range, find what letter it is
;(ASCII65 Is A)->(65 - 55 = 10 = A)
    SUBI    #55, D2         
    ROL.L   #4, D3              ;Make room to add a new byte in D3
    ADD.B   D2, D3              ;Add next char to D3
    BRA     STR_READ            ;Read next char
    
ATOI_DONE:
    MOVE.B  #14, D0      
    TRAP    #15             ;Print A1
    RTS                     ;Return to main

*-----------------------------------------------------------
*PROG_READER: Reads program instructions from start (A4) to finish (A5)
*A3: Saves Data
*A4: Iterates through address spaces
*A5: Holds end address
*A6: Temp Address Register
*D1: Designates corresponding error code
*D2: Holds Current instruction
*D3: Modifies instructions for use
*D4: Temp register for calculations
*D5: Tracks the buffer for printing to screen
*D6: Temp register for calculations
PROG_READER:
    LEA     OP_TABLE, A0 ;Loads Opcode Table into A0
    LEA     BUFFER, A2   ;Sets A2 to the buffer location
    LEA     EA_STACK, A3 ;Sets A3 to save data before jumping to EA functions
    CLR     D1           ;Clears all data before use (Not D5 since its tracking print lines)
    CLR     D2
    CLR     D3
    CLR     D4
    CLR     D6
    CLR     D7   
    
    MOVE.L  A4, D3       ;Prepare to read address
    CLR     D6
    MOVE.B  #8, D6       ;Amount of digits to read for ITOA
    MOVE.B  #36, (A2)+   ;Begin memory address with $ symbol
    JSR     ITOA         ;Calculate memory address
    MOVE.B  #32, (A2)+   :Space
    MOVE.W  (A4)+, D2    ;D2 Contains current instruction
    MOVE.W  D2, D3       ;Copy into D3 so that D2 is not lost
    MOVE.B  #12, D4      ;Move the amount we want to shift D3 by into D4
    LSR.W   D4, D3       ;D3 now contains only the first 4 bits of opcode
    MULU    #6, D3       ;Calculate jump table displacement
    JMP     0(A0, D3)    ;Jump to opcode
    
PRINT_LINE:
    SUBI    #1, D5       ;Increment lines printed print counter
    
    MOVE.B  #0, (A2)+    ;0 = Terminate
    LEA     BUFFER, A1   ;Print Buffer
    MOVE.B  #13, D0
    TRAP    #15
    JSR     BUFFER_CLEAR ;Clear Buffer
    
    CMPI    #0, D5
    BEQ     BUFFER_PAUSE ;Check if we need to pause buffer
    
    
    BRA     CHECK_END

BUFFER_PAUSE:
    
    LEA     MSG_BUFFER, A1    ;Say buffer is paused
    MOVE.B  #13, D0
    TRAP    #15
    LEA     STACK, A1   ;Move A1 to stack
    MOVE.B  #2, D0      ;Put trash in stack
    TRAP    #15
    MOVE.B  #21, D5     ;Reset buffer count
    BRA     PRINT_LINE
    
BUFFER_CLEAR:
    CLR.L   D4
    MOVE.B  BUFFER_SIZE, D4 ;D4 is the counter
    LEA     BUFFER, A2
BUF_CLEAR_LOOP:
    MOVE.B  #0, (A2)+   ;Clears a character
    SUBI    #1, D4      ;Count down D4
    BGT     BUF_CLEAR_LOOP  ;Loop while D4 is bigger than 1
    LEA     BUFFER, A2  ;Reset A2 to buffer
    RTS                 ;Return
    
CHECK_END:
    
    CMPA.L  A4, A5      ;If A4 passes A5, we are done
    BLT     CONCLUDE_READER
    BRA     PROG_READER
    
CONCLUDE_READER:
    BRA     Q_RESTART                   ;Ask to do program again

*========== OP TABLE ==========
OP_TABLE:
    JMP code0000
    JMP code0001        ;MOVE.B
    JMP code0010        ;MOVE.L/MOVEA
    JMP code0011        ;MOVE.W/MOVEA
    JMP code0100        ;CLR/NOP/RTS/JSR/MOVEM/LEA
    JMP code0101        ;ADDQ/SUBQ
    JMP code0110        ;Bcc
    JMP code0111        ;MOVEQ
    JMP code1000        ;DIVU/OR
    JMP code1001        ;SUB
    JMP OP_UNSUPPORTED  ;UNSUPPORTED
    JMP code1011        ;CMP
    JMP code1100        ;MULU/MULS/AND
    JMP code1101        ;ADDA
    JMP code1110        ;ASL/ASR/LSL/LSR/ROL/ROR
    JMP OP_UNSUPPORTED
    
*========== Opcodes ==========
*OPCODE FUNCTIONS FOUND BELOW

code0000:
    LEA     code0000_TABLE, A0  ;Load Table into A0
    
    MOVE.W  D2, D3          ;Move D2 into D3 to check if ADDI or SUBI
    ANDI.W  #$0E00, D3      ;Bits 9-11 identifies instructions
    ROL.W   #7, D3          ;Rotate to front of register
    CMPI    #7, D3
    MULU    #6, D3
    JMP     0(A0,D3)
    
code0000_RESUME:
    
    BRA PRINT_LINE
    
code0000_TABLE:
    JMP     OP_ORI      ;0
    JMP     OP_ANDI     ;1
    JMP     OP_SUBI     ;2
    JMP     OP_ADDI     ;3
    JMP     OP_UNSUPPORTED
    JMP     OP_EORI     ;5
    JMP     OP_CMPI     ;6
    JMP     OP_UNSUPPORTED
    
code0001:
*MOVE.B
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    MOVE.B  #'.', (A2)+
    MOVE.B  #'B', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MOVE
    MOVE.B  -(A3), D5       ;Load current print line from stack
    BRA PRINT_LINE
code0010:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    JSR    OP_MOVE          ;Determine wheter MOVEA or MOVE
    MOVE.B  #'.', (A2)+
    MOVE.B  #'L', (A2)+
    CMPI    #1, D4          ;If MOVEA D4 is set to 1
    BEQ     EA_MOVEA_CALL
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MOVE
    MOVE.B  -(A3), D5
code0010_END:
    BRA PRINT_LINE
EA_MOVEA_CALL:
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MOVEA
    MOVE.B  -(A3), D5
    BRA     code0010_END
code0011:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    JSR     OP_MOVE         ;Determine wheter MOVEA or MOVE
    CMPI    #1, D4          ;If MOVEA D4 is set to 1
    BEQ     EA_MOVEA_CALL
    MOVE.B  #'.', (A2)+
    MOVE.B  #'W', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MOVE
    MOVE.B  -(A3), D5
    BRA PRINT_LINE
code0100:
    ;Check LEA
    LEA     code0100_TABLE, A0  ;Load Table into A0
    MOVE.W  D2, D3              ;Modify instruction for LEA
    ANDI.W  #$01C0, D3          ;Isolate bits 6,7,8 to check for LEA
    ROR.W   #6, D3              ;Check if bits are 111
    CMPI    #7, D3              ;Check if bits are 111
    BEQ     OP_LEA              ;Determine if LEA function
    
    ;Instructions identified by bits 9-12 CLR/NOT
    MOVE.W  D2, D3              ;Modify instruction for CLR
    ANDI.W  #$0F00, D3          ;Isolate 3rd hex digit
    ROL.W   #8, D3              ;Rotate to front
    CMPI    #2, D3
    BEQ     OP_CLR              ;Determine if CLR function
    CMPI    #6, D3
    BEQ     OP_NOT              ;Determine if NOT function
    
    ;CHECK EXT AND/OR MOVEM
    MOVE.W  D2, D3
    ANDI.W  #$0F80, D3          ;Isolate areas of interest
    ROR.W   #7, D3
    CMPI    #17, D3             ;If bits 12 and 8 are set
    BEQ     OP_EXT              ;EXT identified
    
    ;CHECK MOVEM
    MOVE.W  D2, D3              ;Modify instruction for MOVEM
    ANDI.W  #$0FFF, D3          ;Isolate areas of interst
    MOVE.B  #9, D4
    LSR.W   D4, D3              ;Move area of interest to the front
    CMPI    #6, D3              ;Determine if MOVEM function
    BLE     OP_MOVEM_TEST
    
    ;Check TRAP
    MOVE.W  D2, D3
    ANDI.W  #$0E40, D3          ;Just compare instruction to the fixed bits
    CMPI    #$0E40, D3
    BEQ     OP_TRAP
    
    
    ;Check if can be identified by jump table
    MOVE.W  D2, D3
    ANDI    #$0F00, D3
    ROR.W   #8, D3
    CMPI    #14, D3
    BEQ     code0100_PART2      ;Else check all other code
    BRA     OP_UNSUPPORTED
    
code0100_PART2:
    MOVE.W  D2, D3              ;Check for JSR
    ANDI    #$01C0, D3          ;Isolate bits of interest
    ROR.W   #6, D3
    CMPI    #2, D3              ;If bit 8 is set and not 7 and 9
    BEQ     OP_JSR              ;JSR FOUND
    CMPI    #3, D3
    BEQ     OP_JMP              ;JMP FOUND
    
    MOVE.W  D2, D3              ;Check for MULU.L
    ANDI    #$0FC0, D3          ;Isolate bits 6 through 11
    ROR.W   #6, D3              ;Move bits to front
    CMPI    #48, D3             ;If only bits 10 and 11 are set
    BEQ     OP_MULU_LONG        ;MULU Long identified
    
    MOVE.W  D2, D3              ;Go to table
    ANDI.W  #$000F, D3          ;First nibble identifies instructions
    MULU    #6, D3
    JMP     0(A0,D3)
code0100_TABLE:
*========== code0100 TABLE ==========
    JMP OP_UNSUPPORTED
    JMP OP_NOP                  ;NOP
    JMP OP_STOP                 ;STOP
    JMP OP_RTE                  ;RTE
    JMP OP_UNSUPPORTED
    JMP OP_RTS                  ;RTS
    JMP OP_UNSUPPORTED          ;TRAPV
    JMP OP_UNSUPPORTED
    JMP OP_UNSUPPORTED          


code0100_RESUME:
    
    BRA PRINT_LINE
code0101:
    MOVE.W  D2, D3
    ANDI    #$0F00, D3          ;Isolate bits of interest
    LSL.W   #7, D3              
    ROL.W   #1, D3
    CMPI    #1, D3              ;Determine if SUBQ or ADDQ
    BEQ     OP_SUBQ
    BRA     OP_ADDQ
code0110:
    ;BCC instructions
    LEA     BCC_TABLE, A0       ;BCC table loaded
    MOVE.W  D2, D3
    ANDI    #$0F00, D3
    ROL.W   #8, D3              ;Rotate bits of interest to the front
    MULU    #6, D3              ;Prepare D3 for jump table
    JMP     0(A0,D3)            ;Compare D3 to jump table
    
code0110_RESUME:
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_BCC
    MOVE.B  -(A3), D5
    MOVE.W  (A4)+, D3       ;Increment A4 forward since function does not do that
    CLR     D3
    BRA PRINT_LINE
 
*========== code0110 TABLE ==========
BCC_TABLE:
    JMP OP_BRA
    JMP OP_BSR
    JMP OP_BHI
    JMP OP_BLS
    JMP OP_BCC
    JMP OP_BCS
    JMP OP_BNE
    JMP OP_BEQ
    JMP OP_BVC
    JMP OP_BVS
    JMP OP_BPL
    JMP OP_BMI
    JMP OP_BGE
    JMP OP_BLT
    JMP OP_BGT
    JMP OP_BLE

code0111:
    BRA OP_MOVEQ
code1000:
    ;Test for DIV/OR
    MOVE.B  D2, D3
    LSR.B   #6, D3
    CMPI    #3, D3  ;If bits 6/7 are set, its DIV
    BEQ     OP_DIV_TEST
    BRA     OP_OR
code1001:
    
    BRA OP_SUB
code1010:

    BRA OP_UNSUPPORTED
code1011:
    MOVE.W  D2, D3
    ANDI    #$0F00, D3
    LSL.W   #7, D3      ;Shift bits out of instruction
    ROL.W   #1, D3      ;Rotate 8th bit to front
    CMPI    #1, D3      ;Determine CMP/EOR
    BEQ     OP_EOR
    BRA     OP_CMP
code1100:
    ;Test for MUL/AND
    MOVE.B  D2, D3
    LSR.B   #6, D3
    CMPI    #3, D3  ;If bits 6/7 are set, its MUL
    BEQ     OP_MULU_TEST
    BRA     OP_AND
code1101:
    ;Test for ADD/ADDA
    MOVE.B  D2, D3
    LSR.B   #6, D3
    CMPI    #3, D3  ;If bits 6/7 are set, its ADDA
    BEQ     OP_ADDA
    BRA     OP_ADD
code1110:
    ;Test for ASd/ROd/LSd
    MOVE.W  D2, D3
    ANDI    #$00C0, D3      ;Isolate bits 7/8
    ROR.W   #6, D3
    CMPI    #3, D3
    BEQ     code1110_SINGLE ;If size bits (7/8) is set to 3 jump to analyzer
    ;ELSE STAY AND CHECK FOR ROTATION                  
    MOVE.W  D2, D3
    ANDI    #$0018, D3      ;Get bits 4 and 5
    ROR     #3, D3
    CMPI    #0, D3
    BEQ     OP_AS_TEST
    CMPI    #1, D3
    BEQ     OP_LS_TEST
    CMPI    #3, D3
    BEQ     OP_RO_TEST
    BRA     OP_UNSUPPORTED
    
code1110_SINGLE:
    ;When Size is set to 11
    MOVE.W  D2, D3
    ANDI    #$0F00, D3      ;These bits determine rotation
    ROL     #8, D3
    CMPI    #0, D3
    BEQ     OP_ASR_SINGLE
    CMPI    #1, D3
    BEQ     OP_ASL_SINGLE
    CMPI    #2, D3
    BEQ     OP_LSR_SINGLE
    CMPI    #3, D3
    BEQ     OP_LSL_SINGLE
    CMPI    #4, D3
    BEQ     OP_ROR_SINGLE
    CMPI    #5, D3
    BEQ     OP_ROL_SINGLE
    BRA     OP_UNSUPPORTED
    
OP_AS_IMMEDIATE:
    MOVE.W  D2, D3
    ANDI    #$0018, D3      ;Get bits 4 and 5
    ROR     #3, D3
    CMPI    #0, D3
    BEQ     OP_AS_TEST
    CMPI    #1, D3
    BEQ     OP_LS_TEST
    CMPI    #3, D3
    BEQ     OP_RO_TEST
    BRA     OP_UNSUPPORTED
    
OP_AS_DATA:
    MOVE.W  D2, D3
    ANDI    #$0F00, D3
    ROL.W   #8, D3
    CMPI    #0, D3  ;0 = ASR
    BEQ     OP_ASR
    CMPI    #1, D3  ;1 = ASL
    BEQ     OP_ASL
    CMPI    #2, D3  ;2 = LSR
    BEQ     OP_LSR
    CMPI    #3, D3  ;3 = LSL
    BEQ     OP_LSL
    CMPI    #6, D3  ;6 = ROR
    BEQ     OP_ROR
    CMPI    #0, D3  ;7 = ROL
    BEQ     OP_ROL
    ;Test 2
    
    
code1110_RESUME:
    ;After determining Operation, Direction, and size.
    MOVE.W  D2, D3      ;Now we determine whether immediate or register call through
    ANDI    #$0020, D3  ;Isolate bit 6
    ROR.W   #5, D3      ;Isolate bit 6
    CMPI    #0, D3      ;Determine whether memory or register operation
    BEQ     OP_MEM_CALL
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ASL_REG
    MOVE.B  -(A3), D5
    BRA     code1110_END
code1110_RESUME_SINGLE:
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ASL_MEM
    MOVE.B  -(A3), D5
code1110_END:
    BRA     PRINT_LINE
OP_MEM_CALL:
;CALLS ASL MEMORY EA FUNCTION
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ASL_MEM
    MOVE.B  -(A3), D5
    BRA     code1110_END
code1111:

    BRA OP_UNSUPPORTED

*-----------------------------------------------------------
*Extra Opcode Functions
OP_ORI:
    MOVE.B  #'O', (A2)+
    MOVE.B  #'R', (A2)+
    MOVE.B  #'I', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDI
    MOVE.B  -(A3), D5
    BRA     code0000_RESUME

OP_ANDI:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'N', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'I', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDI
    MOVE.B  -(A3), D5
    BRA     code0000_RESUME

OP_SUBI:
    MOVE.B  #'S', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'B', (A2)+
    MOVE.B  #'I', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDI
    MOVE.B  -(A3), D5
    BRA     code0000_RESUME
    
OP_ADDI:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'I', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDI
    MOVE.B  -(A3), D5

    BRA     code0000_RESUME
    
OP_EORI:
    MOVE.B  #'E', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'R', (A2)+
    MOVE.B  #'I', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDI
    MOVE.B  -(A3), D5
    BRA     code0000_RESUME
OP_CMPI:
    MOVE.B  #'C', (A2)+
    MOVE.B  #'M', (A2)+
    MOVE.B  #'P', (A2)+
    MOVE.B  #'I', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDI
    MOVE.B  -(A3), D5
    BRA     code0000_RESUME
OP_MOVE:

    MOVE.W  D2, D3
    LSL.W   #7, D3
    MOVE.B  #13, D4
    LSR.W   D4, D3
    CMPI    #1, D3
    BEQ     OP_MOVEA
    CLR     D4          ;D4 has a flag that determines whether MOVE or MOVEA was used
    RTS
    
OP_MOVEA:
    MOVE.B  #'A', (A2)+
    CLR     D4
    MOVE.B  #1, D4      ;D4 has a flag that determines whether MOVE or MOVEA was used
    RTS

OP_CLR:
    MOVE.B  #'C', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'R', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_CLR
    MOVE.B  -(A3), D5
    BRA     code0100_RESUME
   
OP_MOVEM_TEST:
;ALSO tests LEA
    MOVE.W  D2, D3
    ANDI    #$0FF0, D3      ;Isolate areas of interest
    LSR.W   #7, D3          
    CMPI    #25, D3         ;If the mode bit is set
    BEQ     OP_MOVEM
    CMPI    #17, D3         ;If the mode bit is not set
    BEQ     OP_MOVEM
    BRA     OP_UNSUPPORTED

OP_MOVEM:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    MOVE.B  #'.', (A2)+
    MOVE.B  #'M', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MOVEM
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_NOP:
    MOVE.B  #'N', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'P', (A2)+

    BRA     PRINT_LINE
OP_RTS:
    MOVE.B  #'R', (A2)+
    MOVE.B  #'T', (A2)+
    MOVE.B  #'S', (A2)+
    
    BRA     PRINT_LINE

OP_JSR:
    MOVE.B  #'J', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'R', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_JSR
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_JMP:
    MOVE.B  #'J', (A2)+
    MOVE.B  #'M', (A2)+
    MOVE.B  #'P', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_JSR
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE

OP_LEA:

    MOVE.B  #'L', (A2)+
    MOVE.B  #'E', (A2)+
    MOVE.B  #'A', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_LEA
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_ADDQ:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'Q', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDQ
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
OP_SUBQ:
    MOVE.B  #'S', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'B', (A2)+
    MOVE.B  #'Q', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDQ
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_MOVEQ:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    MOVE.B  #'Q', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MOVEQ
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE

OP_DIV_TEST:
    MOVE.W  D2, D3
    ANDI    #$0F00, D3
    LSL.W   #7, D3      ;Shift bits out of instruction
    ROL.W   #1, D3      ;Rotate 8th bit to front
    CMPI    #1, D3      ;Determine DIVS/DIVU
    BEQ     OP_DIVS
    BRA     OP_DIVU
    
OP_DIVU:
    MOVE.B  #'D', (A2)+
    MOVE.B  #'I', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MULU_WORD
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_DIVS:
    MOVE.B  #'D', (A2)+
    MOVE.B  #'I', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MULU_WORD
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE

OP_OR:
    MOVE.B  #'O', (A2)+
    MOVE.B  #'R', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_OR
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_SUB:
    MOVE.B  #'S', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'B', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADD
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
OP_CMP:
    MOVE.B  #'C', (A2)+
    MOVE.B  #'M', (A2)+
    MOVE.B  #'P', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADD
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_EXT:
    ;Not done identifying EXT yet
    MOVE.W  D2, D3
    ANDI    #$0038, D3
    ROR.W   #3, D3
    CMPI    #0, D3
    BNE     OP_MOVEM_TEST      ;If bits 4-6 are set its not EXT could be MOVEM
    MOVE.B  #'E', (A2)+
    MOVE.B  #'X', (A2)+
    MOVE.B  #'T', (A2)+
    MOVE.W  D2, D3          ;Check Size
    ANDI    #$0040, D3      ;Search for bit 7
    ROR.W   #6, D3
    CMPI    #0, D3          ;0 is word
    BEQ     OP_EXT_WORD
    BRA     OP_EXT_LONG     ;1 is long
    
OP_EXT_RESUME:
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_EXT
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
OP_EXT_WORD:
    MOVE.B  #'.', (A2)+
    MOVE.B  #'W', (A2)+
    BRA     OP_EXT_RESUME

OP_EXT_LONG:
    MOVE.B  #'.', (A2)+
    MOVE.B  #'L', (A2)+
    BRA     OP_EXT_RESUME

OP_NOT:
    MOVE.B  #'N', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'T', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_CLR          ;EA_CLR works for NOT
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_TRAP:
    MOVE.B  #'T', (A2)+
    MOVE.B  #'R', (A2)+
    MOVE.B  #'A', (A2)+
    MOVE.B  #'P', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_TRAP          
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE

OP_STOP:
    MOVE.B  #'S', (A2)+
    MOVE.B  #'T', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'P', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_STOP         
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_RTE:
    MOVE.B  #'R', (A2)+
    MOVE.B  #'T', (A2)+
    MOVE.B  #'E', (A2)+
    BRA     PRINT_LINE

OP_EOR:
    MOVE.B  #'E', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'R', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_EOR        
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_MULU_TEST:
    MOVE.W  D2, D3
    ANDI    #$0F00, D3
    LSL.W   #7, D3      ;Shift bits out of instruction
    ROL.W   #1, D3      ;Rotate 8th bit to front
    CMPI    #1, D3      ;Determine MULS/MULU
    BEQ     OP_MULS
    BRA     OP_MULU
 
OP_MULU:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MULU_WORD
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_MULU_LONG:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'.', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MULU_LONG
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE

    
OP_MULS:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_MULU_WORD
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE

OP_AND:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'N', (A2)+
    MOVE.B  #'D', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_OR
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE
    
OP_ADD:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'D', (A2)+
    JSR     BITSIZE6
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADD
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE

OP_ADDA:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'A', (A2)+
    JSR     BITSIZE8
    MOVE.B  #SPC, (A2)+     ;Space to separate OP from EA
    MOVE.B  D5, (A3)+       ;Save data to stack (not used by calculator)
    ;Clear all registers
    CLR     D0
    CLR     D1
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    JSR     EA_ADDA
    MOVE.B  -(A3), D5
    BRA     PRINT_LINE

OP_AS_TEST:
    MOVE.W  D2, D3
    ANDI    #$0100, D3
    ROL.W   #8, D3      ;If 8th bit is 1 ASL, else ASR
    CMPI    #1, D3
    BEQ     OP_ASL
    BRA     OP_ASR
OP_ASR:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'R', (A2)+
    JSR     BITSIZE6
    BRA     code1110_RESUME 
OP_ASR_SINGLE:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'R', (A2)+
    BRA     code1110_RESUME_SINGLE

OP_ASL:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'L', (A2)+
    JSR     BITSIZE6
    BRA     code1110_RESUME
OP_ASL_SINGLE:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'L', (A2)+
    BRA     code1110_RESUME_SINGLE

OP_LS_TEST:
    MOVE.W  D2, D3
    ANDI    #$0100, D3
    ROL.W   #8, D3      ;If 8th bit is 1 LSL, else LSR
    CMPI    #1, D3
    BEQ     OP_LSL
    BRA     OP_LSR
    
OP_LSR:
    MOVE.B  #'L', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'R', (A2)+
    JSR     BITSIZE6
    BRA     code1110_RESUME
OP_LSR_SINGLE:
    MOVE.B  #'L', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'R', (A2)+
    BRA     code1110_RESUME_SINGLE
OP_LSL:
    MOVE.B  #'L', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'L', (A2)+
    JSR     BITSIZE6
    BRA     code1110_RESUME
OP_LSL_SINGLE:
    MOVE.B  #'L', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'L', (A2)+
    BRA     code1110_RESUME_SINGLE
    
OP_RO_TEST:
    MOVE.W  D2, D3
    ANDI    #$0100, D3
    ROL.W   #8, D3      ;If 8th bit is 1 ROL, else ROR
    CMPI    #1, D3
    BEQ     OP_ROL
    BRA     OP_ROR
OP_ROR:
    MOVE.B  #'R', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'R', (A2)+
    JSR     BITSIZE6
    BRA     code1110_RESUME
OP_ROR_SINGLE:
    MOVE.B  #'R', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'R', (A2)+
    BRA     code1110_RESUME_SINGLE
OP_ROL:
    MOVE.B  #'R', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'L', (A2)+
    JSR     BITSIZE6
    BRA     code1110_RESUME
OP_ROL_SINGLE:
    MOVE.B  #'R', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'L', (A2)+
    BRA     code1110_RESUME_SINGLE
    
OP_BRA:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'R', (A2)+
    MOVE.B  #'A', (A2)+
    
    BRA     code0110_RESUME
    
OP_BSR:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'R', (A2)+
    
    BRA     code0110_RESUME
    
OP_BHI:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'H', (A2)+
    MOVE.B  #'I', (A2)+
    
    BRA     code0110_RESUME 
    
OP_BLS:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'S', (A2)+
    
    BRA     code0110_RESUME
    
OP_BCC:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'C', (A2)+
    MOVE.B  #'C', (A2)+
    
    BRA     code0110_RESUME
    
OP_BCS:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'C', (A2)+
    MOVE.B  #'S', (A2)+
    
    BRA     code0110_RESUME
    
OP_BNE:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'N', (A2)+
    MOVE.B  #'E', (A2)+
    
    BRA     code0110_RESUME
    
OP_BEQ:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'E', (A2)+
    MOVE.B  #'Q', (A2)+
    
    BRA     code0110_RESUME
    
OP_BVC:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'C', (A2)+
    
    BRA     code0110_RESUME
    
OP_BVS:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'S', (A2)+
    
    BRA     code0110_RESUME
    
OP_BPL:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'P', (A2)+
    MOVE.B  #'L', (A2)+
    
    BRA     code0110_RESUME
    
OP_BMI:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'M', (A2)+
    MOVE.B  #'I', (A2)+
    
    BRA     code0110_RESUME
    
OP_BGE:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'G', (A2)+
    MOVE.B  #'E', (A2)+
    
    BRA     code0110_RESUME
    
OP_BLT:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'T', (A2)+
    
    BRA     code0110_RESUME
    
OP_BGT:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'G', (A2)+
    MOVE.B  #'T', (A2)+
    
    BRA     code0110_RESUME
    
OP_BLE:
    MOVE.B  #'B', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'E', (A2)+
    
    BRA     code0110_RESUME
   
OP_UNSUPPORTED:
    MOVE.B  #1, D1
    BRA     ERROR_HANDLER
*---------------------------------------------------------------
ITOA:
*A2: Print Buffer
*A4: Holds current address
*D3: Temp register for calculations
*D4: Temp register for calculations
*D6: Tracks how many digits in the instruction have been read
    ROL.L   #4, D3
    MOVE.B  D3, D4
    ANDI    #$000F, D4
    CMPI    #9, D4
    BGT     ITOA_DIGIT
    ADDI    #48, D4
    MOVE.B  D4, (A2)+
    BRA     ITOA_END
ITOA_DIGIT:
    ADDI    #55, D4
    MOVE.B  D4, (A2)+
    BRA     ITOA_END
ITOA_END:
    SUBI    #1, D6
    BGT     ITOA
    RTS
    
*---------------------------------------------------------------
BITSIZE6:
*Checks the size of an operation. Byte, Word or Long.
*A2: Address register for printing
*D2: Instruction
*D3: Temporary use register
    MOVE.B  D2, D3
    ANDI    #$C0, D3
    ROL.B   #2, D3  ;Rotate interest bits to front
    CMPI.B  #0, D3  ;Test if byte operation
    BEQ     BITSIZE_BYTE
    CMPI.B  #1, D3  ;Test if word operation
    BEQ     BITSIZE_WORD
    CMPI.B  #2, D3  ;Test if long operation
    BEQ     BITSIZE_LONG
    MOVE.B  #0, D1
    BRA     ERROR_HANDLER
    
BITSIZE8:
    MOVE.B  D2, D3
    ANDI    #$0100, D3  ;Isolate bit 8
    MOVE.B  #9, D4
    ROR.W   D4, D3      ;Rotate bit to front
    CMPI    #1, D3      ;Check size for word or long
    BEQ     BITSIZE_LONG    ;Add word to buffer
    BRA     BITSIZE_WORD    ;Add Long to buffer
    
BITSIZE_BYTE:
    MOVE.B  #'.', (A2)+
    MOVE.B  #'B', (A2)+ ;Print .B
    RTS                 ;Return to wherever you came from
    
BITSIZE_WORD:
    MOVE.B  #'.', (A2)+
    MOVE.B  #'W', (A2)+ ;Print .W
    RTS                 ;Return to wherever you came from
    
BITSIZE_LONG:
    MOVE.B  #'.', (A2)+
    MOVE.B  #'L', (A2)+ ;Print .L
    RTS                 ;Return to wherever you came from
*___________________________________________________________
*~~~~~~~~~~~~~~~~~~~EA CALCULATIONS~~~~~~~~~~~~~~~~~~~~~~~~~
EA_ADD:                 ;Also works for SUB and CMPI
*Get first three bits (source register)
            MOVE    #3, D4
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
            JMP     EA_FINISH
            
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
            CMPI    #0, D6
            BEQ     E_INPUT
            CMPI    #4, D6
            BEQ     E_INPUT
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
            MOVE.B  #'(', (A2)+
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     ADDCONTINUE5
            
ADDLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     ADDCONTINUE5

            
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
            JMP     ADDCONTINUE5


            
ADDDB:
            JMP     E_INPUT
ADDAB:
            JMP     E_INPUT
ADDDEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH 
ADDPOSTADDAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     EA_FINISH 
ADDPRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
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
            JMP     EA_FINISH
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
            JMP     EA_FINISH
                        
ADDWORDB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
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
 
            JMP     EA_FINISH
            
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+        
            JMP     EA_FINISH

            
ADDDATAB:
            JMP     E_INPUT

*___________________________________________________________            
EA_ADDA:                 
*Get first three bits (source register)
            MOVE    #3, D4
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
            BCS     ADDAADD4
ADDAOPCONTINUE:
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDAOPNEXT
            JMP     ADDAOPLOOP

ADDAOPNEXT:
*Get next three bits (destination register)
            ROL     #3, D1
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
            ROL     #3, D6
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
            JMP     EA_FINISH
            
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
            MOVE.B  #'(', (A2)+
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     ADDACONTINUE5
            
ADDALONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     ADDACONTINUE5
           
ADDADATAA:
            JMP     E_INPUT


*___________________________________________________________
EA_ADDI:                 
*Get first three bits (destination register)
            MOVE    #3, D4
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
            CMPI    #4, D3
            BEQ     ADDIDATAA
            
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
            JMP     EA_FINISH
ADDIAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     EA_FINISH
ADDIDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH 
ADDIPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     EA_FINISH 
ADDIPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
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
            JMP     EA_FINISH
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
            JMP     EA_FINISH
            
ADDIWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
            
ADDILONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH
ADDIDATAA:
            JMP     E_INPUT

*___________________________________________________________
EA_ADDQ:      ;Also works for SUBQ           
*Get first three bits (destination register)
            MOVE    #3, D4
ADDQLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDQADD1
ADDQCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQNEXT1
            JMP     ADDQLOOP1
    
*Get next three bits (destination mode)
ADDQNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
ADDQLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDQADD2
ADDQCONTINUE2:
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQNEXT2
            JMP     ADDQLOOP2
            
*Get next two bits (size)
ADDQNEXT2:
            ROL     #3, D5
            MOVE    #2, D4
ADDQSIZELOOP:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDQADD4
ADDQSIZECONTINUE:
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQNEXTSIZE
            JMP     ADDQSIZELOOP
            
*Skip next bit
ADDQNEXTSIZE:
            ROL     #2, D1
            LSR     #1, D2

*Get next three bits (data)
            MOVE    #3, D4
ADDQLOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ADDQADD3
ADDQCONTINUE3:
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQNEXT3
            JMP     ADDQLOOP3

*Print out data:
ADDQNEXT3:
            ROL     #3, D6
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            MOVE.B  #' ', (A2)+

*Print out destination mode
            CMPI    #0, D5
            BEQ     ADDQDA
            CMPI    #1, D5
            BEQ     ADDQAA
            CMPI    #2, D5
            BEQ     ADDQDEREGISTERAA
            CMPI    #3, D5
            BEQ     ADDQPOSTADDAA
            CMPI    #4, D5
            BEQ     ADDQPRESUBAA
            CMPI    #5, D5
            BEQ     ADDQD16AA
            CMPI    #6, D5
            BEQ     ADDQD8AXA
            CMPI    #7, D5
            BEQ     ADDQWLD1        
ADDQWLD1:
            CMPI    #0, D1
            BEQ     ADDQWORDA
            CMPI    #1, D1
            BEQ     ADDQLONGA
            CMPI    #4, D1
            BEQ     ADDQDATAA
            
ADDQADD1:
            ADDI    #1, D3
            JMP     ADDQCONTINUE1
    
ADDQADD2:
            ADDI    #1, D5
            JMP     ADDQCONTINUE2
ADDQADD3:
            ADDI    #1, D6
            JMP     ADDQCONTINUE3
ADDQADD4:
            ADDI    #1, D1
            JMP     ADDQSIZECONTINUE
    
ADDQDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     EA_FINISH
ADDQAA:
            CMPI    #0, D1
            BEQ     E_INPUT
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     EA_FINISH

ADDQDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH 

ADDQPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     EA_FINISH 

ADDQPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH

ADDQD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
ADDQD8AXA:
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
            JMP     EA_FINISH
            
ADDQWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ADDQLOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDQSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDQCONTINUE4:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ADDQNEXT4
            JMP     ADDQLOOP4
            
ADDQSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDQCONTINUE4

ADDQNEXT4:
            MOVE    #4, D4
ADDQLOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQWORDFINAL
            JMP     ADDQLOOP5
ADDQWORDFINAL:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
ADDQLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ADDQLOOP8:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ADDQSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ADDQCONTINUE7:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ADDQNEXT5
            JMP     ADDQLOOP8
            
ADDQSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ADDQCONTINUE7

ADDQNEXT5:
            MOVE    #8, D4
ADDQLOOP9:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ADDQLONGFINAL
            JMP     ADDQLOOP9
ADDQLONGFINAL:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH
            
ADDQDATAA:
            JMP     E_INPUT



*___________________________________________________________
EA_ASL_MEM:
*Get first three bits (register)
            MOVE    #3, D4
              
ASLMEMLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLMEMADD1
ASLMEMCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLMEMNEXT1
            JMP     ASLMEMLOOP1
    
*Get next three bits (mode)
ASLMEMNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
ASLMEMLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLMEMADD2
ASLMEMCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLMEMNEXT2
            JMP     ASLMEMLOOP2

*Print out EA
ASLMEMNEXT2:
            ROL     #3, D5
            CMPI    #0, D5
            BEQ     ASLMEMDA
            CMPI    #1, D5
            BEQ     ASLMEMAA
            CMPI    #2, D5
            BEQ     ASLMEMDEREGISTERAA
            CMPI    #3, D5
            BEQ     ASLMEMPOSTADDAA
            CMPI    #4, D5
            BEQ     ASLMEMPRESUBAA
            CMPI    #5, D5
            BEQ     ASLMEMD16AA
            CMPI    #6, D5
            BEQ     ASLMEMD8AXA
            CMPI    #7, D5
            BEQ     ASLMEMWLD1

ASLMEMWLD1:
            CMPI    #0, D3
            BEQ     ASLMEMWORDA
            CMPI    #1, D3
            BEQ     ASLMEMLONGA
            
ASLMEMADD1:
            ADDI    #1, D3
            JMP     ASLMEMCONTINUE1
    
ASLMEMADD2:
            ADDI    #1, D5
            JMP     ASLMEMCONTINUE2
    
ASLMEMDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH
ASLMEMAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH
ASLMEMDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH 
ASLMEMPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH 
ASLMEMPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH
ASLMEMD16AA:
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
            JMP     EA_FINISH
ASLMEMD8AXA:
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
            JMP     EA_FINISH
            
ASLMEMWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ASLMEMLOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ASLMEMSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ASLMEMCONTINUE4:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ASLMEMNEXT3
            JMP     ASLMEMLOOP4
            
ASLMEMSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ASLMEMCONTINUE4

ASLMEMNEXT3:
            MOVE    #4, D4
ASLMEMLOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLMEMWORDFINISH
            JMP     ASLMEMLOOP5
ASLMEMWORDFINISH:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
            
ASLMEMLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ASLMEMLOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ASLMEMSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ASLMEMCONTINUE5:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ASLMEMNEXT4
            JMP     ASLMEMLOOP6
            
ASLMEMSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ASLMEMCONTINUE5

ASLMEMNEXT4:
            MOVE    #8, D4
ASLMEMLOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLMEMLONGFINISH
            JMP     ASLMEMLOOP7
ASLMEMLONGFINISH:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH
*-----------------------------------------------------------
EA_ASL_REG:                 
*Get first three bits (destination register)
            MOVE    #3, D4
ASLREGLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLREGADD1
ASLREGCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLREGNEXT1
            JMP     ASLREGLOOP1
    
*Skip next two bits
ASLREGNEXT1:
            ROL     #3, D3
            LSR     #2, D2
            
*Get next bit (i/r)
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLREGADD2           
            
*Skip three bits 
ASLREGNEXT2:
            LSR     #3, D2

*Get next three bits (count/register)
            MOVE    #3, D4
ASLREGLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ASLREGADD3
ASLREGCONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ASLREGNEXT3
            JMP     ASLREGLOOP2
            
*Decide if we are set to count or register
ASLREGNEXT3:
            ROL     #3, D6
            CMP     #0, D5
            BEQ     ASLREGCOUNT
*Register goes here:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     EA_FINISH       
            
ASLREGCOUNT:
            MOVE.B  #'#', (A2)+
            CMPI    #0, D6
            BEQ     ASLREGZEROTOEIGHT
ASLREGCONTINUE4:
            ADD     #'0', D6
            MOVE.B   D6, (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     EA_FINISH
            
ASLREGZEROTOEIGHT:
            MOVE.B  #8, D6
            JMP     ASLREGCONTINUE4
            
ASLREGADD1:
            ADDI    #1, D3
            JMP     ASLREGCONTINUE1
    
ASLREGADD2:
            ADDI    #1, D5
            JMP     ASLREGNEXT2
ASLREGADD3:
            ADDI    #1, D6
            JMP     ASLREGCONTINUE3    
*-----------------------------------------------------------
EA_BCC:                 
*Get first eight bits (8-bit displacement)
            MOVE    #8, D4
BCCLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     BCCADD1
BCCCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     BCCNEXT1
            JMP     BCCLOOP1
BCCNEXT1:
*Get current address (A4 - 2)
            ROL     #8, D3
            MOVE    A4, D6
*See if we are getting byte displacement, word displacement, or long displacement
            CMPI    #$00, D3
            BEQ     BCCWORDDIS
            CMPI    #$FF, D3
            BEQ     BCCLONGDIS
*If code reached here, we're byte displacement
            ADD.B   D3, D6
            JMP     BCCNEXT2

BCCWORDDIS:
            MOVE    (A4)+, D5
            ADD     D5, D6
            JMP     BCCNEXT2

BCCLONGDIS:
            MOVE.L  (A4)+, D5
            ADD.L   D5, D6
            JMP     BCCNEXT2
            
*Print out current address plus displacement
BCCNEXT2:
            MOVE.B  #'$', (A2)+
            MOVE    #8, D4
BCCLOOP2:
            MOVE.B  D6, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     BCCSINGLEDGT1
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
BCCCONTINUE2:  
            SUB     #1, D4
            LSR.L   #4, D6
            CMPI    #0, D4
            BEQ     BCCNEXT3
            JMP     BCCLOOP2
            
BCCSINGLEDGT1:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     BCCCONTINUE2

BCCNEXT3:
            MOVE    #8, D4
BCCLOOP3:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     BCCNEXT4
            JMP     BCCLOOP3
BCCNEXT4:
            JMP     EA_FINISH
            
BCCADD1:
            ADDI    #1, D3
            JMP     BCCCONTINUE1       
*-----------------------------------------------------------
EA_CLR:                 ;Also works for NOT, 
*Get first three bits (register)
            MOVE    #3, D4
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
            JMP     CLRLOOP3

*Print out EA
CLRNEXT3:
            ROL     #2, D1
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
            JMP     EA_FINISH
CLRAA:
            JMP    E_INPUT
CLRDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH 
CLRPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH 
CLRPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH
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
            JMP     EA_FINISH
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
            JMP     EA_FINISH
            
CLRWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
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
            BEQ     CLRWORDFINISH
            JMP     CLRLOOP5
CLRWORDFINISH:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
            
CLRLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
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
            BEQ     CLRLONGFINISH
            JMP     CLRLOOP7
CLRLONGFINISH:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH
            
CLRDATAA:
            JMP     E_INPUT    



*-----------------------------------------------------------
EA_MOVE:                 
*Get first three bits (source register)
            MOVE    #3, D4
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
            ROL     #2, D1
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
            MOVE.B  #'(', (A2)+
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVENEXT5
            
MOVELONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4)+, D5
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+ 
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
            MOVE    (A4)+, D5
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
            JMP     EA_FINISH
MOVEAB:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     EA_FINISH
MOVEDEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH 
MOVEPOSTADDAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     EA_FINISH 
MOVEPRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
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
            JMP     EA_FINISH
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
            JMP     EA_FINISH
            
MOVEWORDB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4)+, D5
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
            
MOVELONGB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4)+, D5
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH

            
MOVEDATAB:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     MOVEWORDA
            CMPI    #2, D1
            BEQ     MOVELONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4)+, D5
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
            JMP     EA_FINISH
*-----------------------------------------------------------
EA_MOVEA:                 
*Get first three bits (source register)
            MOVE    #3, D4
MOVEALOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEAADD1
MOVEACONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT1
            JMP     MOVEALOOP1
    
*Get next three bits (source mode)
MOVEANEXT1:
            ROL     #3, D3
            MOVE    #3, D4
MOVEALOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEAADD2
MOVEACONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT2
            JMP     MOVEALOOP2
            
*Skip next three bits (not needed)
MOVEANEXT2:
            ROL     #3, D5
            LSR     #3, D2          
*Get next three bits (destination register)
            MOVE    #3, D4
MOVEALOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEAADD3
MOVEACONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT3
            JMP     MOVEALOOP3

*Get next two bits (size)
MOVEANEXT3:
            ROL     #3, D6
            MOVE    #2, D4
MOVEALOOP4:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEAADD4
MOVEACONTINUE4:  
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEASOURCE
            JMP     MOVEALOOP4
            

*Print out source address
MOVEASOURCE:
            ROL     #2, D1
            CMPI    #0, D5
            BEQ     MOVEADA
            CMPI    #1, D5
            BEQ     MOVEAAA
            CMPI    #2, D5
            BEQ     MOVEADEREGISTERAA
            CMPI    #3, D5
            BEQ     MOVEAPOSTADDAA
            CMPI    #4, D5
            BEQ     MOVEAPRESUBAA
            CMPI    #5, D5
            BEQ     MOVEAD16AA
            CMPI    #6, D5
            BEQ     MOVEAD8AXA
            CMPI    #7, D5
            BEQ     MOVEAWLD1
            
*Print out destination address
MOVEANEXT5:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            JMP     EA_FINISH
            
MOVEAWLD1:
            CMPI    #0, D3
            BEQ     MOVEAWORDA
            CMPI    #1, D3
            BEQ     MOVEALONGA
            CMPI    #4, D3
            BEQ     MOVEADATAA
            
MOVEAADD1:
            ADDI    #1, D3
            JMP     MOVEACONTINUE1
    
MOVEAADD2:
            ADDI    #1, D5
            JMP     MOVEACONTINUE2
MOVEAADD3:
            ADDI    #1, D6
            JMP     MOVEACONTINUE3

MOVEAADD4:
            ADDI    #1, D1
            JMP     MOVEACONTINUE4
    
MOVEADA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
MOVEAAA:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
MOVEADEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5 
MOVEAPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5 
MOVEAPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
MOVEAD16AA:
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
            JMP     MOVEANEXT5
MOVEAD8AXA:
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
            JMP     MOVEANEXT5
            
MOVEAWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4)+, D5
            MOVE    #4, D4
MOVEALOOP5:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEASINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEACONTINUE5:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVEANEXT6
            JMP     MOVEALOOP5
            
MOVEASINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEACONTINUE5

MOVEANEXT6:
            MOVE    #4, D4
MOVEALOOP6:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT7
            JMP     MOVEALOOP6
MOVEANEXT7:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5
            
MOVEALONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4)+, D5
            MOVE    #8, D4
MOVEALOOP7:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEASINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEACONTINUE6:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MOVEANEXT8
            JMP     MOVEALOOP7
            
MOVEASINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEACONTINUE6

MOVEANEXT8:
            MOVE    #8, D4
MOVEALOOP8:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEANEXT9
            JMP     MOVEALOOP8
MOVEANEXT9:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5

            
MOVEADATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     MOVEAWORDA
            CMPI    #2, D1
            BEQ     MOVEALONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4)+, D5
            MOVE    #2, D4
MOVEABYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEASINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEABYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MOVEANEXT10
            JMP     MOVEABYTELOOP1
            
MOVEASINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEABYTECONTINUE1

MOVEANEXT10:
            MOVE    #2, D4
MOVEABYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEABYTENEXT1
            JMP     MOVEABYTELOOP2
            
MOVEABYTENEXT1:
            MOVE.B  #' ', (A2)+
            JMP     MOVEANEXT5                 


*-----------------------------------------------------------
EA_MOVEM:                 
*Get first three bits (EA register)
            MOVE    #3, D4
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
            JMP     EA_FINISH
            
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
            MOVE.B  #'(', (A2)+
            MOVE    (A4)+, D5
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMCONTINUE4
            
MOVEMLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4)+, D5
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     MOVEMCONTINUE4
            
       
            
MOVEMDEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
MOVEMPRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
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
            JMP     EA_FINISH
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
            JMP     EA_FINISH
            
MOVEMWORDB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4)+, D5
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
            
MOVEMLONGB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4)+, D5
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
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH

            
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
*-----------------------------------------------------------
EA_MOVEQ:                 
*Get first eight bits (data)
            MOVE    #8, D4
MOVEQLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEQADD1
MOVEQCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEQNEXT1
            JMP     MOVEQLOOP1
    
*Skip next bit
MOVEQNEXT1:
            ROL     #8, D3
            LSR     #1, D2
            
*Get next three bits (destination register)   
            MOVE    #3, D4
MOVEQLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MOVEQADD2
MOVEQCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEQNEXT2
            JMP     MOVEQLOOP2

*Print out EA
MOVEQNEXT2:
            ROL     #3, D5
            MOVE    #4, D4
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
MOVEQLOOP3:
            MOVE.B  D3, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MOVEQSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MOVEQCONTINUE3:  
            SUB     #1, D4
            LSR     #4, D3
            CMPI    #0, D4
            BEQ     MOVEQNEXT3
            JMP     MOVEQLOOP3
            
MOVEQSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MOVEQCONTINUE3

MOVEQNEXT3:
            MOVE    #4, D4
MOVEQLOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MOVEQNEXT4
            JMP     MOVEQLOOP4
MOVEQNEXT4:           
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D5
            MOVE.B  D5, (A2)+
            JMP     EA_FINISH
            
MOVEQADD1:
            ADDI    #1, D3
            JMP     MOVEQCONTINUE1
    
MOVEQADD2:
            ADDI    #1, D5
            JMP     MOVEQCONTINUE2     
*-----------------------------------------------------------
EA_MULU_WORD:                 ;Also works for MULS, DIVS, DIVU (word)
*Get first three bits (source register)
            MOVE    #3, D4
MULUWORDLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MULUWORDADD1
MULUWORDCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUWORDNEXT1
            JMP     MULUWORDLOOP1
    
*Get next three bits (source mode)
MULUWORDNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
MULUWORDLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MULUWORDADD2
MULUWORDCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUWORDNEXT2
            JMP     MULUWORDLOOP2
            
            
*Skip three bits   
MULUWORDNEXT2:
            ROL     #3, D5
            LSR     #3, D2

*Get next three bits (destination register)
            MOVE    #3, D4
MULUWORDLOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MULUWORDADD3
MULUWORDCONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUWORDNEXT3
            JMP     MULUWORDLOOP3
            
*Print address
MULUWORDNEXT3:
            ROL     #3, D6   
            CMPI    #0, D5
            BEQ     MULUWORDDA
            CMPI    #1, D5
            BEQ     MULUWORDAA
            CMPI    #2, D5
            BEQ     MULUWORDDEREGISTERAA
            CMPI    #3, D5
            BEQ     MULUWORDPOSTADDAA
            CMPI    #4, D5
            BEQ     MULUWORDPRESUBAA
            CMPI    #5, D5
            BEQ     MULUWORDD16AA
            CMPI    #6, D5
            BEQ     MULUWORDD8AXA
            CMPI    #7, D5
            BEQ     MULUWORDWLD1
MULUWORDCONTINUE5:  
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            JMP     EA_FINISH
            
MULUWORDWLD1:
            CMPI    #0, D3
            BEQ     MULUWORDWORDA
            CMPI    #1, D3
            BEQ     MULUWORDLONGA
            CMPI    #4, D3
            BEQ     MULUWORDDATAA
            
MULUWORDADD1:
            ADDI    #1, D3
            JMP     MULUWORDCONTINUE1
    
MULUWORDADD2:
            ADDI    #1, D5
            JMP     MULUWORDCONTINUE2
MULUWORDADD3:
            ADDI    #1, D6
            JMP     MULUWORDCONTINUE3
    
MULUWORDDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     MULUWORDCONTINUE5
MULUWORDAA:
           JMP    E_INPUT
MULUWORDDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULUWORDCONTINUE5
MULUWORDPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     MULUWORDCONTINUE5
MULUWORDPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULUWORDCONTINUE5
MULUWORDD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULUWORDCONTINUE5
MULUWORDD8AXA:
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
            JMP     MULUWORDCONTINUE5
                   
MULUWORDWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4)+, D5
            MOVE    #4, D4
MULUWORDLOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULUWORDSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULUWORDCONTINUE6:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MULUWORDNEXT4
            JMP     MULUWORDLOOP4
            
MULUWORDSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULUWORDCONTINUE6

MULUWORDNEXT4:
            MOVE    #4, D4
MULUWORDLOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUWORDFINISHWORD1
            JMP     MULUWORDLOOP5
            
MULUWORDFINISHWORD1:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     MULUWORDCONTINUE5

            
MULUWORDLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4)+, D5
            MOVE    #8, D4
MULUWORDLOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULUWORDSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULUWORDCONTINUE7:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MULUWORDNEXT5
            JMP     MULUWORDLOOP6
            
MULUWORDSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULUWORDCONTINUE7

MULUWORDNEXT5:
            MOVE    #8, D4
MULUWORDLOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUWORDFINISHLONG1
            JMP     MULUWORDLOOP7
            
MULUWORDFINISHLONG1:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     MULUWORDCONTINUE5
            
MULUWORDDATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     MULUWORDWORDA
            CMPI    #2, D1
            BEQ     MULUWORDLONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4)+, D5
            MOVE    #2, D4
MULUWORDBYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULUWORDSINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULUWORDBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MULUWORDNEXT6
            JMP     MULUWORDBYTELOOP1
            
MULUWORDSINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULUWORDBYTECONTINUE1

MULUWORDNEXT6:
            MOVE    #2, D4
MULUWORDBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULUWORDBYTENEXT1
            JMP     MULUWORDBYTELOOP2
            
MULUWORDBYTENEXT1:
            JMP     MULUWORDCONTINUE5

EA_MULU_LONG:                 ;Also works for MULS, DIVS, DIVU (long)
*Get first three bits (source register)
            MOVE    #3, D4
MULULONGLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MULULONGADD1
MULULONGCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULULONGNEXT1
            JMP     MULULONGLOOP1
    
*Get next three bits (source mode)
MULULONGNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
MULULONGLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     MULULONGADD2
MULULONGCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULULONGNEXT3
            JMP     MULULONGLOOP2
            
            
*Print source address
MULULONGNEXT3:
            ROL     #3, D5
            MOVE    (A4)+, D1   
            CMPI    #0, D5
            BEQ     MULULONGDA
            CMPI    #1, D5
            BEQ     MULULONGAA
            CMPI    #2, D5
            BEQ     MULULONGDEREGISTERAA
            CMPI    #3, D5
            BEQ     MULULONGPOSTADDAA
            CMPI    #4, D5
            BEQ     MULULONGPRESUBAA
            CMPI    #5, D5
            BEQ     MULULONGD16AA
            CMPI    #6, D5
            BEQ     MULULONGD8AXA
            CMPI    #7, D5
            BEQ     MULULONGWLD1
MULULONGCONTINUE5:  
            MOVE.B  #' ', (A2)+
            
*Get next three bits (destination register Dh)
            MOVE    #3, D4
MULULONGDLOOP1:
            CMPI    #1, D1
            LSR     #1, D1
            BCS     MULULONGADD4
MULULONGDCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULULONGDNEXT1
            JMP     MULULONGDLOOP1
            
MULULONGDNEXT1:
*Skip next seven bits
            ROL     #3, D3
            LSR     #7, D1
            
*Get next bit (size)
            CMPI    #1, D1
            LSR     #1, D1
            BCS     MULULONGADD5
            
MULULONGDCONTINUE2:
*Skip next bit
            LSR     #1, D1
*Get next three bits (destination register Dl)
            MOVE    #3, D4
MULULONGDLOOP2:
            CMPI    #1, D1
            LSR     #1, D1
            BCS     MULULONGADD6
MULULONGDCONTINUE3:
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULULONGDNEXT2
            JMP     MULULONGDLOOP2
            
MULULONGDNEXT2:
*Print out destination register
            ROL     #3, D6
            CMPI    #0, D5
            BEQ     MULULONGDLONLY
            CMP     D3, D6
            BEQ     MULULONGDLONLY
*Print both Dh and Dl
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #'-', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            JMP     EA_FINISH

MULULONGDLONLY:     ;Print only Dl
            MOVE.B  #'D', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            JMP     EA_FINISH
            
MULULONGWLD1:
            CMPI    #0, D3
            BEQ     MULULONGWORDA
            CMPI    #1, D3
            BEQ     MULULONGLONGA
            CMPI    #4, D3
            BEQ     MULULONGDATAA
            
MULULONGADD1:
            ADDI    #1, D3
            JMP     MULULONGCONTINUE1
    
MULULONGADD2:
            ADDI    #1, D5
            JMP     MULULONGCONTINUE2
MULULONGADD4:
            ADDI    #1, D3
            JMP     MULULONGDCONTINUE1
MULULONGADD5:
            ADDI    #1, D5
            JMP     MULULONGDCONTINUE2
MULULONGADD6:
            ADDI    #1, D6
            JMP     MULULONGDCONTINUE3
    
MULULONGDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     MULULONGCONTINUE5
MULULONGAA:
            JMP    E_INPUT
MULULONGDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULULONGCONTINUE5
MULULONGPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     MULULONGCONTINUE5
MULULONGPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULULONGCONTINUE5
MULULONGD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     MULULONGCONTINUE5
MULULONGD8AXA:
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
            JMP     MULULONGCONTINUE5
                   
MULULONGWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
MULULONGLOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULULONGSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULULONGCONTINUE6:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MULULONGNEXT4
            JMP     MULULONGLOOP4
            
MULULONGSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULULONGCONTINUE6

MULULONGNEXT4:
            MOVE    #4, D4
MULULONGLOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            JMP     MULULONGLOOP5

MULULONGWORDFINISH:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     MULULONGCONTINUE5
            
MULULONGLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
MULULONGLOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULULONGSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULULONGCONTINUE7:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     MULULONGNEXT5
            JMP     MULULONGLOOP6
            
MULULONGSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULULONGCONTINUE7

MULULONGNEXT5:
            MOVE    #8, D4
MULULONGLOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULULONGLONGFINISH
            JMP     MULULONGLOOP7
            
MULULONGLONGFINISH:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     MULULONGCONTINUE5
            
MULULONGDATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     MULULONGWORDA
            CMPI    #2, D1
            BEQ     MULULONGLONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
MULULONGBYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     MULULONGSINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
MULULONGBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     MULULONGNEXT6
            JMP     MULULONGBYTELOOP1
            
MULULONGSINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     MULULONGBYTECONTINUE1

MULULONGNEXT6:
            MOVE    #2, D4
MULULONGBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     MULULONGBYTENEXT1
            JMP     MULULONGBYTELOOP2
            
MULULONGBYTENEXT1:
            JMP     MULULONGCONTINUE5
*-----------------------------------------------------------
EA_JSR:                 ;Also used for LEA, JMP
*Get first three bits (register)
            MOVE    #3, D4
JSRLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     JSRADD1
JSRCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     JSRNEXT1
            JMP     JSRLOOP1
    
*Get next three bits (mode)
JSRNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
JSRLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     JSRADD2
JSRCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     JSRNEXT2
            JMP     JSRLOOP2
      
*Get next two bits (size)      
JSRNEXT2:
            ROL     #3, D5
            MOVE    #2, D4
JSRLOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     JSRADD3
JSRCONTINUE3:  
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     JSRNEXT3
            JMP     JSRLOOP3

*Print out EA
JSRNEXT3:
            ROL     #2, D1
            CMPI    #0, D5
            BEQ     JSRDA
            CMPI    #1, D5
            BEQ     JSRAA
            CMPI    #2, D5
            BEQ     JSRDEREGISTERAA
            CMPI    #3, D5
            BEQ     JSRPOSTADDAA
            CMPI    #4, D5
            BEQ     JSRPRESUBAA
            CMPI    #5, D5
            BEQ     JSRD16AA
            CMPI    #6, D5
            BEQ     JSRD8AXA
            CMPI    #7, D5
            BEQ     JSRWLD1

JSRWLD1:
            CMPI    #0, D3
            BEQ     JSRWORDA
            CMPI    #1, D3
            BEQ     JSRLONGA
            CMPI    #4, D3
            BEQ     JSRDATAA
            
JSRADD1:
            ADDI    #1, D3
            JMP     JSRCONTINUE1
    
JSRADD2:
            ADDI    #1, D5
            JMP     JSRCONTINUE2
JSRADD3:
            ADDI    #1, D6
            JMP     JSRCONTINUE3
    
JSRDA:
            JMP     E_INPUT
JSRAA:
            JMP     E_INPUT
JSRDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EA_FINISH 
JSRPOSTADDAA:
            JMP     E_INPUT
JSRPRESUBAA:
            JMP     E_INPUT
JSRD16AA:
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
            JMP     EA_FINISH
JSRD8AXA:
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
            JMP     EA_FINISH
            
JSRWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4)+, D5
            MOVE    #4, D4
JSRLOOP4:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     JSRSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
JSRCONTINUE4:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     JSRNEXT4
            JMP     JSRLOOP4
            
JSRSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     JSRCONTINUE4

JSRNEXT4:
            MOVE    #4, D4
JSRLOOP5:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     JSRWORDFINISH
            JMP     JSRLOOP5
            
JSRWORDFINISH:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
            
JSRLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4)+, D5
            MOVE    #8, D4
JSRLOOP6:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     JSRSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
JSRCONTINUE5:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     JSRNEXT5
            JMP     JSRLOOP6
            
JSRSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     JSRCONTINUE5

JSRNEXT5:
            MOVE    #8, D4
JSRLOOP7:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     JSRLONGFINISH
            JMP     JSRLOOP7
            
JSRLONGFINISH:
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH
            
JSRDATAA:
            JMP     E_INPUT    
*-----------------------------------------------------------
EA_LEA:                 
*Get first three bits (source register)
            MOVE    #3, D4
LEALOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     LEAADD1
LEACONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     LEANEXT1
            JMP     LEALOOP1
    
*Get next three bits (source mode)
LEANEXT1:
            ROL     #3, D3
            MOVE    #3, D4
LEALOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     LEAADD2
LEACONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     LEANEXT2
            JMP     LEALOOP2
            
*Skip next three bits (not needed)
LEANEXT2:
            ROL     #3, D5
            LSR     #3, D2          
*Get next three bits (destination register)
            MOVE    #3, D4
LEALOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     LEAADD3
LEACONTINUE3:  
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     LEANEXT3
            JMP     LEALOOP3

*Get next two bits (size)
LEANEXT3:
            ROL     #3, D6
            MOVE    #2, D4
LEALOOP4:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     LEAADD4
LEACONTINUE4:  
            ROR     #1, D1
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     LEASOURCE
            JMP     LEALOOP4
            

*Print out source address
LEASOURCE:
            ROL     #2, D1
            CMPI    #0, D5
            BEQ     LEADA
            CMPI    #1, D5
            BEQ     LEAAA
            CMPI    #2, D5
            BEQ     LEADEREGISTERAA
            CMPI    #3, D5
            BEQ     LEAPOSTADDAA
            CMPI    #4, D5
            BEQ     LEAPRESUBAA
            CMPI    #5, D5
            BEQ     LEAD16AA
            CMPI    #6, D5
            BEQ     LEAD8AXA
            CMPI    #7, D5
            BEQ     LEAWLD1
            
*Print out destination address
LEANEXT5:
            MOVE.B  #'A', (A2)+
            ADD     #'0', D6
            MOVE.B  D6, (A2)+
            JMP     EA_FINISH
            
LEAWLD1:
            CMPI    #0, D3
            BEQ     LEAWORDA
            CMPI    #1, D3
            BEQ     LEALONGA
            CMPI    #4, D3
            BEQ     LEADATAA
            
LEAADD1:
            ADDI    #1, D3
            JMP     LEACONTINUE1
    
LEAADD2:
            ADDI    #1, D5
            JMP     LEACONTINUE2
LEAADD3:
            ADDI    #1, D6
            JMP     LEACONTINUE3

LEAADD4:
            ADDI    #1, D1
            JMP     LEACONTINUE4
    
LEADA:
            JMP     E_INPUT
LEAAA:
            JMP     E_INPUT
LEADEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     LEANEXT5 
LEAPOSTADDAA:
            JMP     E_INPUT
LEAPRESUBAA:
            JMP     E_INPUT
LEAD16AA:
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
            JMP     LEANEXT5
LEAD8AXA:
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
            JMP     LEANEXT5
            
LEAWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
LEALOOP5:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     LEASINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
LEACONTINUE5:  
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     LEANEXT6
            JMP     LEALOOP5
            
LEASINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     LEACONTINUE5

LEANEXT6:
            MOVE    #4, D4
LEALOOP6:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     LEANEXT7
            JMP     LEALOOP6
LEANEXT7:           
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+ 
            MOVE.B  #' ', (A2)+
            JMP     LEANEXT5
            
LEALONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4)+, D5
            MOVE    #8, D4
LEALOOP7:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     LEASINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
LEACONTINUE6:  
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     LEANEXT8
            JMP     LEALOOP7
            
LEASINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     LEACONTINUE6

LEANEXT8:
            MOVE    #8, D4
LEALOOP8:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     LEANEXT9
            JMP     LEALOOP8
LEANEXT9:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     LEANEXT5
            
LEADATAA:
            JMP     E_INPUT
*-----------------------------------------------------------
EA_EXT:                 
*Get first three bits (register)
            MOVE    #3, D4
EXTLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     EXTADD1
EXTCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EXTNEXT1
            JMP     EXTLOOP1
    
*Skip next three bits
EXTNEXT1:
           ROL     #3, D3
           LSR     #3, D2
*Get next three bits (opmode)
            MOVE    #3, D4
EXTLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     EXTADD2
EXTCONTINUE2:  
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EXTNEXT2
            JMP     EXTLOOP2

*Print out EA
EXTNEXT2:
            ROL     #3, D5
            MOVE.B  #'D', (A2)+
            ADD     #0, D3
            MOVE    D3, (A2)+
            MOVE.B  #'e', (A2)+
            MOVE.B  #'x', (A2)+
            MOVE.B  #'t', (A2)+
            MOVE.B  #'e', (A2)+
            MOVE.B  #'n', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #' ', (A2)+
            CMPI    #2, D5
            BEQ     EXTBYTETOWORD
            CMPI    #3, D5
            BEQ     EXTWORDTOLONG
*If code reached here, we're going from byte to long
            MOVE.B  #'b', (A2)+
            MOVE.B  #'y', (A2)+
            MOVE.B  #'t', (A2)+
            MOVE.B  #'e', (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'t', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'l', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #'n', (A2)+
            MOVE.B  #'g', (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'w', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #'r', (A2)+
            MOVE.B  #'d', (A2)+
            JMP     EA_FINISH

EXTBYTETOWORD:
            MOVE.B  #'b', (A2)+
            MOVE.B  #'y', (A2)+
            MOVE.B  #'t', (A2)+
            MOVE.B  #'e', (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'t', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'w', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #'r', (A2)+
            MOVE.B  #'d', (A2)+
            JMP     EA_FINISH

EXTWORDTOLONG:
            MOVE.B  #'w', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #'r', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'t', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'l', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #'n', (A2)+
            MOVE.B  #'g', (A2)+
            MOVE.B  #' ', (A2)+
            MOVE.B  #'w', (A2)+
            MOVE.B  #'o', (A2)+
            MOVE.B  #'r', (A2)+
            MOVE.B  #'d', (A2)+
            JMP     EA_FINISH

EXTADD1:
            ADDI    #1, D3
            JMP     EXTCONTINUE1
    
EXTADD2:
            ADDI    #1, D5
            JMP     EXTCONTINUE2

EA_TRAP:                 
*Get first four bits (vector)
            MOVE    #4, D4
TRAPLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     TRAPADD1
TRAPCONTINUE1:  
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     TRAPNEXT1
            JMP     TRAPLOOP1
    
*Print out EA
TRAPNEXT1:
            ROL     #4, D3
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
            MOVE    #4, D4
TRAPLOOP2:
            MOVE.B  D3, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     TRAPSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
TRAPCONTINUE2: 
            SUB     #1, D4
            LSR.L   #4, D3
            CMPI    #0, D4
            BEQ     TRAPNEXT2
            JMP     TRAPLOOP2
            
TRAPSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     TRAPCONTINUE2

TRAPNEXT2:
            MOVE    #4, D4
TRAPLOOP3:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EA_FINISH
            JMP     TRAPLOOP3


TRAPADD1:
            ADDI    #1, D3
            JMP     TRAPCONTINUE1
*-----------------------------------------------------------
EA_STOP:                 
*Move immediate data into buffer
            MOVE.B  #'#', (A2)+
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
STOPLOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     STOPSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
STOPCONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     STOPNEXT1
            JMP     STOPLOOP1
            
STOPSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     STOPCONTINUE1

STOPNEXT1:
            MOVE    #4, D4
STOPLOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     STOPNEXT2
            JMP     STOPLOOP2
STOPNEXT2:            
            JMP     EA_FINISH
*-----------------------------------------------------------
EA_EOR:                 
*Get first three bits (source register)
            MOVE    #3, D4
EORLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     EORADD1
EORCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EORNEXT1
            JMP     EORLOOP1
    
*Get next three bits (source mode)
EORNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
EORLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     EORADD2
EORCONTINUE2:
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EORNEXT2
            JMP     EORLOOP2
            
*Get next three bits (opmode)   
EORNEXT2:
            ROL     #3, D5
            MOVE    #3, D4
EORLOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     EORADD3
EORCONTINUE3:
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EORNEXT3
            JMP     EORLOOP3
            
*Get next three bits (destination register)
EORNEXT3:
            ROL     #3, D6
            MOVE    #3, D4
EORLOOP4:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     EORADD4
EORCONTINUE4:
            ROR     #1, D7
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EORNEXT4
            JMP     EORLOOP4

*Figure out which is source and which is destination via opcode
EORNEXT4:
            ROL     #3, D7
            MOVE    #1, D1  ;Is it a byte?
            CMPI    #0, D6
            JMP     EORNEXT5
            MOVE    #3, D1  ;Is it a word?
            CMPI    #1, D6
            JMP     EORNEXT5
            MOVE    #2, D1  ;Is it a long?
            CMPI    #2, D6
            JMP     EORNEXT5
            MOVE    #1, D1  ;Is it a byte?
            CMPI    #4, D6
            JMP     EORNEXT6
            MOVE    #3, D1  ;Is it a word?
            CMPI    #5, D6
            JMP     EORNEXT6
            MOVE    #2, D1  ;Is it a long?
            CMPI    #6, D6
            JMP     EORNEXT6
            

EORNEXT5:    ;If the format is <ea>, Dn -> Dn
            CMPI    #0, D5
            BEQ     EORDA
            CMPI    #1, D5
            BEQ     EORAA
            CMPI    #2, D5
            BEQ     EORDEREGISTERAA
            CMPI    #3, D5
            BEQ     EORPOSTADDAA
            CMPI    #4, D5
            BEQ     EORPRESUBAA
            CMPI    #5, D5
            BEQ     EORD16AA
            CMPI    #6, D5
            BEQ     EORD8AXA
            CMPI    #7, D5
            BEQ     EORWLD1
EORCONTINUE5:
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     EA_FINISH
            
EORNEXT6:    ;If the format is Dn, <ea> -> <ea>
            MOVE.B  #'D', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #' ', (A2)+
            CMPI    #0, D5
            BEQ     EORDB
            CMPI    #1, D5
            BEQ     EORAB
            CMPI    #2, D5
            BEQ     EORDEREGISTERAB
            CMPI    #3, D5
            BEQ     EORPOSTADDAB
            CMPI    #4, D5
            BEQ     EORPRESUBAB
            CMPI    #5, D5
            BEQ     EORD16AB
            CMPI    #6, D5
            BEQ     EORD8AXB
            CMPI    #7, D5
            BEQ     EORWLD2

*Check register            
EORWLD1:
            CMPI    #0, D3
            BEQ     EORWORDA
            CMPI    #1, D3
            BEQ     EORLONGA
            CMPI    #4, D3
            BEQ     EORDATAA

EORWLD2:
            CMPI    #0, D7
            BEQ     EORWORDB
            CMPI    #1, D7
            BEQ     EORLONGB
            CMPI    #4, D7
            BEQ     EORDATAB
            
EORADD1:
            ADDI    #1, D3
            JMP     EORCONTINUE1
    
EORADD2:
            ADDI    #1, D5
            JMP     EORCONTINUE2
EORADD3:
            ADDI    #1, D6
            JMP     EORCONTINUE3
EORADD4:
            ADDI    #1, D7
            JMP     EORCONTINUE4
    
EORDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     EORCONTINUE5
EORAA:
            JMP     E_INPUT
EORDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EORCONTINUE5
EORPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     EORCONTINUE5
EORPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EORCONTINUE5
EORD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EORCONTINUE5
EORD8AXA:
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
            JMP     EORCONTINUE5
            
EORWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
EORLOOP5:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     EORSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
EORCONTINUE6:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     EORNEXT7
            JMP     EORLOOP5
            
EORSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     EORCONTINUE6

EORNEXT7:
            MOVE    #4, D4
EORLOOP6:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EORNEXT8
            JMP     EORLOOP6
EORNEXT8:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EORNEXT5
            
EORLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
EORLOOP7:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     EORSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
EORCONTINUE7:
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     EORNEXT9
            JMP     EORLOOP7
            
EORSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     EORCONTINUE7

EORNEXT9:
            MOVE    #8, D4
EORLOOP8:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EORNEXT10
            JMP     EORLOOP8
EORNEXT10:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     EORNEXT5
            
EORDATAA:
            JMP     E_INPUT
            
EORDB:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     EA_FINISH 
EORAB:
            JMP     E_INPUT
EORDEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH 
EORPOSTADDAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     EA_FINISH 
EORPRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
EORD16AB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
EORD8AXB:
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
            JMP     EA_FINISH
                        
EORWORDB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
EORLOOP9:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     EORSINGLEDGT4
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
EORCONTINUE9:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     EORNEXT12
            JMP     EORLOOP9
            
EORSINGLEDGT4:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     EORCONTINUE6

EORNEXT12:
            MOVE    #4, D4
EORLOOP10:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EORNEXT13
            JMP     EORLOOP10
EORNEXT13:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
            
EORLONGB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
EORLOOP11:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     EORSINGLEDGT5
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
EORCONTINUE10:
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     EORNEXT14
            JMP     EORLOOP11
            
EORSINGLEDGT5:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     EORCONTINUE10

EORNEXT14:
            MOVE    #8, D4
EORLOOP12:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     EORNEXT14
            JMP     EORLOOP12
EOREXT15:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH

            
EORDATAB:
            JMP     E_INPUT
*-----------------------------------------------------------
EA_OR:                 ;Also works for AND
*Get first three bits (source register)
            MOVE    #3, D4
ORLOOP1:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ORADD1
ORCONTINUE1:
            ROR     #1, D3
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORNEXT1
            JMP     ORLOOP1
    
*Get next three bits (source mode)
ORNEXT1:
            ROL     #3, D3
            MOVE    #3, D4
ORLOOP2:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ORADD2
ORCONTINUE2:
            ROR     #1, D5
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORNEXT2
            JMP     ORLOOP2
            
*Get next three bits (opmode)   
ORNEXT2:
            ROL     #3, D5
            MOVE    #3, D4
ORLOOP3:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ORADD3
ORCONTINUE3:
            ROR     #1, D6
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORNEXT3
            JMP     ORLOOP3
            
*Get next three bits (destination register)
ORNEXT3:
            ROL     #3, D6
            MOVE    #3, D4
ORLOOP4:
            CMPI    #1, D2
            LSR     #1, D2
            BCS     ORADD4
ORCONTINUE4:
            ROR     #1, D7
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORNEXT4
            JMP     ORLOOP4

*Figure out which is source and which is destination via opcode
ORNEXT4:
            ROL     #3, D7
            MOVE    #1, D1  ;Is it a byte?
            CMPI    #0, D6
            JMP     ORNEXT5
            MOVE    #3, D1  ;Is it a word?
            CMPI    #1, D6
            JMP     ORNEXT5
            MOVE    #2, D1  ;Is it a long?
            CMPI    #2, D6
            JMP     ORNEXT5
            MOVE    #1, D1  ;Is it a byte?
            CMPI    #4, D6
            JMP     ORNEXT6
            MOVE    #3, D1  ;Is it a word?
            CMPI    #5, D6
            JMP     ORNEXT6
            MOVE    #2, D1  ;Is it a long?
            CMPI    #6, D6
            JMP     ORNEXT6
            

ORNEXT5:    ;If the format is <ea>, Dn -> Dn
            CMPI    #0, D5
            BEQ     ORDA
            CMPI    #1, D5
            BEQ     ORAA
            CMPI    #2, D5
            BEQ     ORDEREGISTERAA
            CMPI    #3, D5
            BEQ     ORPOSTADDAA
            CMPI    #4, D5
            BEQ     ORPRESUBAA
            CMPI    #5, D5
            BEQ     ORD16AA
            CMPI    #6, D5
            BEQ     ORD8AXA
            CMPI    #7, D5
            BEQ     ORWLD1
ORCONTINUE5:
            MOVE.B  #' ', (A2)+
            MOVE.B  #'D', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     EA_FINISH
            
ORNEXT6:    ;If the format is Dn, <ea> -> <ea>
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #' ', (A2)+
            CMPI    #0, D5
            BEQ     ORDB
            CMPI    #1, D5
            BEQ     ORAB
            CMPI    #2, D5
            BEQ     ORDEREGISTERAB
            CMPI    #3, D5
            BEQ     ORPOSTADDAB
            CMPI    #4, D5
            BEQ     ORPRESUBAB
            CMPI    #5, D5
            BEQ     ORD16AB
            CMPI    #6, D5
            BEQ     ORD8AXB
            CMPI    #7, D5
            BEQ     ORWLD2

*Check register            
ORWLD1:
            CMPI    #0, D3
            BEQ     ORWORDA
            CMPI    #1, D3
            BEQ     ORLONGA
            CMPI    #4, D3
            BEQ     ORDATAA

ORWLD2:
            CMPI    #0, D7
            BEQ     ORWORDB
            CMPI    #1, D7
            BEQ     ORLONGB
            CMPI    #4, D7
            BEQ     ORDATAB
            
ORADD1:
            ADDI    #1, D3
            JMP     ORCONTINUE1
    
ORADD2:
            ADDI    #1, D5
            JMP     ORCONTINUE2
ORADD3:
            ADDI    #1, D6
            JMP     ORCONTINUE3
ORADD4:
            ADDI    #1, D7
            JMP     ORCONTINUE4
    
ORDA:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            JMP     ORCONTINUE5
ORAA:
            JMP     E_INPUT
ORDEREGISTERAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ORCONTINUE5
ORPOSTADDAA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     ORCONTINUE5
ORPRESUBAA:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ORCONTINUE5
ORD16AA:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D3
            MOVE.B  D3, (A2)+
            MOVE.B  #')', (A2)+
            JMP     ORCONTINUE5
ORD8AXA:
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
            JMP     ORCONTINUE5
            
ORWORDA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ORLOOP5:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ORSINGLEDGT
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ORCONTINUE6:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ORNEXT7
            JMP     ORLOOP5
            
ORSINGLEDGT:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ORCONTINUE6

ORNEXT7:
            MOVE    #4, D4
ORLOOP6:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORNEXT8
            JMP     ORLOOP6
ORNEXT8:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     ORCONTINUE5
            
ORLONGA:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ORLOOP7:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ORSINGLEDGT2
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ORCONTINUE7:
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ORNEXT9
            JMP     ORLOOP7
            
ORSINGLEDGT2:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ORCONTINUE7

ORNEXT9:
            MOVE    #8, D4
ORLOOP8:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORNEXT10
            JMP     ORLOOP8
ORNEXT10:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            MOVE.B  #' ', (A2)+
            JMP     ORCONTINUE5

            
ORDATAA:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     ORWORDA
            CMPI    #2, D1
            BEQ     ORLONGA
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
ORBYTELOOP1:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ORSINGLEDGT3
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ORBYTECONTINUE1:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ORNEXT11
            JMP     ORBYTELOOP1
            
ORSINGLEDGT3:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ORBYTECONTINUE1

ORNEXT11:
            MOVE    #2, D4
ORBYTELOOP2:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORBYTENEXT1
            JMP     ORBYTELOOP2
            
ORBYTENEXT1:
            MOVE.B  #' ', (A2)+
            JMP     ORCONTINUE5


            
ORDB:
            MOVE.B  #'D', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            JMP     EA_FINISH
ORAB:
            JMP     E_INPUT
ORDEREGISTERAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH 
ORPOSTADDAB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            MOVE.B  #'+', (A2)+
            JMP     EA_FINISH 
ORPRESUBAB:
            MOVE.B  #'-', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
ORD16AB:
            MOVE.B  #'(', (A2)+
            MOVE.B  #'d', (A2)+
            MOVE.B  #'1', (A2)+
            MOVE.B  #'6', (A2)+
            MOVE.B  #',', (A2)+
            MOVE.B  #'A', (A2)+
            ADD     #'0', D7
            MOVE.B  D7, (A2)+
            MOVE.B  #')', (A2)+
            JMP     EA_FINISH
ORD8AXB:
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
            JMP     EA_FINISH
                        
ORWORDB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE    (A4), D5
            MOVE    #4, D4
ORLOOP9:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ORSINGLEDGT4
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ORCONTINUE9:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ORNEXT12
            JMP     ORLOOP9
            
ORSINGLEDGT4:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ORCONTINUE6

ORNEXT12:
            MOVE    #4, D4
ORLOOP10:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORNEXT13
            JMP     ORLOOP10
ORNEXT13:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'W', (A2)+
            JMP     EA_FINISH
            
ORLONGB:
            MOVE.B  #'$', (A2)+
            MOVE.B  #'(', (A2)+
            MOVE.L  (A4), D5
            MOVE    #8, D4
ORLOOP11:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ORSINGLEDGT5
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ORCONTINUE10:
            SUB     #1, D4
            LSR.L   #4, D5
            CMPI    #0, D4
            BEQ     ORNEXT14
            JMP     ORLOOP11
            
ORSINGLEDGT5:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ORCONTINUE10

ORNEXT14:
            MOVE    #8, D4
ORLOOP12:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORNEXT14
            JMP     ORLOOP12
OREXT15:            
            MOVE.B  #')', (A2)+
            MOVE.B  #'.', (A2)+
            MOVE.B  #'L', (A2)+
            JMP     EA_FINISH

            
ORDATAB:
            MOVE.B  #'#', (A2)+
            CMPI    #1, D1
            BEQ     ORWORDB
            CMPI    #2, D1
            BEQ     ORLONGB
*Otherwise, Byte operation
            MOVE.B  #'$', (A2)+
            MOVE    (A4), D5
            MOVE    #2, D4
ORBYTELOOP3:
            MOVE.B  D5, D0
            AND     #$0F, D0
            CMPI    #9, D0
            BLE     ORSINGLEDGT6
            SUB     #10, D0
            ADD     #'A', D0
            MOVE.L  D0, -(A7)
ORBYTECONTINUE2:
            SUB     #1, D4
            LSR     #4, D5
            CMPI    #0, D4
            BEQ     ORNEXT16
            JMP     ORBYTELOOP3
            
ORSINGLEDGT6:
            ADD     #'0', D0
            MOVE.L  D0, -(A7)
            JMP     ORBYTECONTINUE2

ORNEXT16:
            MOVE    #2, D4
ORBYTELOOP4:
            MOVE.L  (A7)+, D0
            MOVE.B  D0, (A2)+   
            SUBI    #1, D4
            CMPI    #0, D4
            BEQ     ORBYTENEXT2
            JMP     ORBYTELOOP4
            
ORBYTENEXT2:
            JMP     EA_FINISH

*-----------------------------------------------------------
EA_FINISH:
            RTS

*-----------------------------------------------------------
*ERROR_HANDLER: When an error occurs, prints error code
ERROR_HANDLER:

    LEA     ERROR_TABLE, A0
    MULU    #6, D1          ;Go to designated code in op table
    JMP     0(A0, D1)

    
ERROR_TABLE:
    JMP     E_UNKNOWN         ;D1 = 0
    JMP     E_UNSUPPORTED     ;D1 = 1
    JMP     E_ADDRESS         ;D1 = 2
    JMP     E_INPUT           ;D1 = 3
    JMP     E_RANGE           ;D1 = 3
    
E_UNKNOWN:
    LEA     MSG_ERROR, A1
    MOVE.B  #14, D0
    TRAP    #15
    BRA     CHECK_END
E_UNSUPPORTED:
    LEA     MSG_UNSUPPORTED, A1
    MOVE.B  #14, D0
    TRAP    #15
    BRA     PRINT_LINE
E_ADDRESS:
    LEA     MSG_ADDRESS, A1
    MOVE.B  #14, D0
    TRAP    #15
    BRA     PRINT_LINE
    BRA     Q_RESTART
E_INPUT:
    LEA     MSG_ADDRESS, A1     ;Invalid Address input, no need to print a line
    MOVE.B  #14, D0 
    TRAP    #15
    BRA     Q_RESTART
E_RANGE:
    LEA     MSG_RANGE, A1     
    MOVE.B  #14, D0 
    TRAP    #15
    BRA     Q_RESTART

*-----------------------------------------------------------

Q_RESTART:
    LEA     PROMPT_RES, A1
    MOVE.B  #14, D0
    TRAP    #15
    
    MOVEA   (A7)+, A1      ;Move A1 to stack so message is not overwritten
    MOVE.B  #2, D0
    TRAP    #15
    
    MOVE.B  (A1)+, D2   ;Move message to D2 to check input
    CMPI.B  #89, D2     ;Check 'Y'
    BEQ     FIND_ADDRESS
    CMPI.B  #121, D2    ;Check 'y'
    BEQ     FIND_ADDRESS
    CMPI.B  #78, D2     ;Check 'N'
    BEQ     END_PROG
    CMPI.B  #110, D2    ;Check 'n'
    BEQ     END_PROG
    BRA     ERROR_HANDLER
    
END_PROG:
    LEA     MSG_END, A1
    MOVE.B  #14, D0
    TRAP    #15
    
    MOVE.B  #9,  D0
    TRAP    #15
    SIMHALT             ; halt simulator




* Put variables and constants here
CR          EQU     $0D
LF          EQU     $0A
SPC         EQU     $20
STACK       EQU     $A0000      ;Stack located at $A0000
EA_STACK    EQU     $A00B0      ;EA_STACK located at $A00B0
nibble2     EQU     $0F00       ;Extract the 2nd nibble
nibble3     EQU     $00F0       ;Extract the 3rd nibble
nibble4     EQU     $000F       ;Extract the 4th nibble
GREETING    DC.B    'Welcome to the Disassembler', CR, LF, 0
PROMPT1     DC.B    'Please select start range of code to disassemble', CR, LF, 0
PROMPT2     DC.B    'Please select end range of code to disassemble', CR, LF, 0
PROMPT_RES  DC.B    'Restart program? Y/N', CR, LF, 0
MSG_END     DC.B    'Ending Program', CR, LF, 0
MSG_ERROR   DC.B    'Error', CR, LF, 0
MSG_UNSUPPORTED DC.B    'Unsupported Opcode', SPC, 0    ;No termination so that this can add address on same line
MSG_ADDRESS DC.B    'Invalid Address', CR, LF, 0
MSG_RANGE   DC.B    'Invalid Range', CR, LF, 0
MSG_BUFFER  DC.B    'Buffer Paused. Press enter to continue.', CR, LF, 0

;Make sure buffer is at end because it gets cleared and everything after it will disappear
BUFFER_SIZE EQU     64          ;Size of buffer
BUFFER      DS.B    BUFFER_SIZE ;Buffer 64 Chars long
    END    START        ; last line of source






























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
