*-----------------------------------------------------------
* Title      :CSS422 Disassembler
* Written by :William T and
* Date       :February 12, 2020
* Description:Final Prjoect for CSS422
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    CLR.B   D7      ;TEST INSTRUCTIONS
    NOP
    JSR     LOSE
    JMP     TE2
    MOVE.B  #3, D6
    BRA     TE1
LOSE:
    RTS
TE1:
    BSR     TE2
TE2:
    CMPI    #4, D6
    BHI     TE3
TE3:
    CMPI    #2, D6
    BLS     TE4
TE4:
    CMPI    #4, D6
    BCC     TE5
TE5:
    CMPI    #4, D6
    BCS     TE6
TE6:
    CMPI    #4, D6
    BNE     TE7
TE7:
    CMPI    #3, D6
    BEQ     TE8
TE8:
    CMPI    #3, D6
    BVC     TE9
TE9:
    BVS     TE10
TE10:
    BPL     TE11
TE11:
    BMI     TE12
TE12:
    BGE     TE13
TE13:
    BLT     TE14
TE14:
    BGT     TE15
TE15:
    BLE     TE16
TE16:
    ADDQ    #6, D0
    MOVE.L  D7, D6
    MOVE.W  D7, D6
    MOVEA.L #$010101, A7
    SUBQ    #6, D0
    CLR     D1
    NOP
    MOVEM   A1, STACK
    LEA     CR, A1
    ADDQ.B  #1, D6
    MOVEQ   #0, D6
    DIVU    #1, D6
    OR      #$0100, D6
    MULU    #2, D6
    MULS    #2, D6
    AND     #00, D6
    ADD.B   D5, D6
    
    ADDA.W  A6, A7
    MOVE.W  D7, D6
    MOVEA.W A0, A1
    MOVEQ   #0, D7
    LEA     STACK, A7   ;stack and stack pointer (A7) at $A0000

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
    
    MOVE.L  A4, D3       ;Prepare to read address
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
    MOVE.W  D2, D3  ;Move D2 into D3 to check if ADDI or SUBI
    MOVE.B  #9, D4  ;We want to rotate 9 bits out of D3
    LSR.W   D4, D3  ;Rotate 9 bits out to check operation
    CMPI.B  #2, D3  ;Compare D3 to 2 for SUBI
    BEQ     OP_SUBI ;Go to SUBI Decoder if it is SUBI
    CMPI.B  #3, D3  ;Compare D3 to 3 for ADDI
    BEQ     OP_ADDI ;Go to ADDI Decoder if it is ADDI
    BRA     OP_UNSUPPORTED  ;UNKNOWN OPCODE
    
code0000_RESUME:
    
    BRA PRINT_LINE
code0001:
*MOVE.B
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    MOVE.B  #'.', (A2)+
    MOVE.B  #'B', (A2)+
    BRA PRINT_LINE
code0010:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    JSR    OP_MOVE          ;Determine wheter MOVEA or MOVE
    MOVE.B  #'.', (A2)+
    MOVE.B  #'L', (A2)+

    BRA PRINT_LINE
code0011:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    JSR     OP_MOVE         ;Determine wheter MOVEA or MOVE
    MOVE.B  #'.', (A2)+
    MOVE.B  #'W', (A2)+
    
    BRA PRINT_LINE
code0100:
    LEA     code0100_TABLE, A0  ;Load Table into A0
    MOVE.W  D2, D3              ;Modify instruction for LEA
    ANDI.W  #$01C0, D3          ;Isolate bits 6,7,8 to check for LEA
    ROR.W   #6, D3              ;Check if bits are 111
    CMPI    #7, D3              ;Check if bits are 111
    BEQ     OP_LEA              ;Determine if LEA function
    
    MOVE.W  D2, D3              ;Modify instruction for CLR
    ANDI.W  #$0F00, D3          ;Isolate 3rd hex digit
    ROL.W   #8, D3              ;Rotate to front
    CMPI    #2, D3
    BEQ     OP_CLR              ;Determine if CLR function
    
    MOVE.W  D2, D3              ;Modify instruction for MOVEM
    ANDI.W  #$0FFF, D3          ;Isolate areas of interst
    MOVE.B  #9, D4
    LSR.W   D4, D3              ;Move area of interest to the front
    CMPI    #6, D3              ;Determine if MOVEM function
    BLE     OP_MOVEM_TEST
    
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
    
    MOVE.W  D2, D3              ;Go to table
    ANDI.W  #$000F, D3          ;First nibble identifies instructions
    MULU    #6, D3
    JMP     0(A0,D3)
code0100_TABLE:
*========== code0100 TABLE ==========
    JMP OP_UNSUPPORTED
    JMP OP_NOP                  ;NOP
    JMP OP_UNSUPPORTED          ;STOP
    JMP OP_UNSUPPORTED          ;RTE
    JMP OP_UNSUPPORTED
    JMP OP_RTS                  ;RTS
    JMP OP_UNSUPPORTED          ;TRAPV
    JMP OP_UNSUPPORTED
    JMP OP_UNSUPPORTED          


code0100_RESUME:
    JSR BITSIZE6
    BRA PRINT_LINE
code0101:
    MOVE.W  D2, D3
    ANDI    #$0F00, D3
    LSL.W   #7, D3
    ROL.W   #1, D3
    CMPI    #1, D3
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
    MOVE.B  #1, D6      ;I use this D6 Flag to check if I need to check for size
    MOVE.W  D2, D3
    ANDI    #$001F, D3
    LSL.W   #3, D3
    CMPI    #0, D3
    BEQ     OP_AS_TEST
    CMPI    #1, D3
    BEQ     OP_LS_TEST
    CMPI    #3, D3
    BEQ     OP_RO_TEST
    
code1111:

    BRA OP_UNSUPPORTED

*-----------------------------------------------------------
*Extra Opcode Functions

OP_SUBI:
    MOVE.B  #'S', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'B', (A2)+
    MOVE.B  #'I', (A2)+
    JSR     BITSIZE6
    BRA     code0000_RESUME
    
OP_ADDI:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'I', (A2)+
    JSR     BITSIZE6
    BRA     code0000_RESUME
    
OP_MOVE:

    MOVE.W  D2, D3
    LSL.W   #7, D3
    MOVE.B  #13, D4
    LSR.W   D4, D3
    CMPI    #1, D3
    BEQ     OP_MOVEA
    RTS
    
OP_MOVEA:
    MOVE.B  #'A', (A2)+
    RTS

OP_CLR:
    MOVE.B  #'C', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'R', (A2)+
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

    BRA     PRINT_LINE
    
OP_JMP:
    MOVE.B  #'J', (A2)+
    MOVE.B  #'M', (A2)+
    MOVE.B  #'P', (A2)+

    BRA     PRINT_LINE

OP_LEA:

    MOVE.B  #'L', (A2)+
    MOVE.B  #'E', (A2)+
    MOVE.B  #'A', (A2)+
    
    BRA     PRINT_LINE
    
OP_ADDQ:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'Q', (A2)+
    JSR     BITSIZE6
    
    BRA     PRINT_LINE
OP_SUBQ:
    MOVE.B  #'S', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'B', (A2)+
    MOVE.B  #'Q', (A2)+
    JSR     BITSIZE6
    
    BRA     PRINT_LINE
    
OP_MOVEQ:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'E', (A2)+
    MOVE.B  #'Q', (A2)+
    
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
    
    BRA     PRINT_LINE
    
OP_DIVS:
    MOVE.B  #'D', (A2)+
    MOVE.B  #'I', (A2)+
    MOVE.B  #'V', (A2)+
    MOVE.B  #'S', (A2)+
    
    BRA     PRINT_LINE

OP_OR:
    MOVE.B  #'O', (A2)+
    MOVE.B  #'R', (A2)+
    JSR     BITSIZE6
    BRA     PRINT_LINE
    
OP_SUB:
    MOVE.B  #'S', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'B', (A2)+
    JSR     BITSIZE6
    BRA     PRINT_LINE
OP_CMP:
    MOVE.B  #'C', (A2)+
    MOVE.B  #'M', (A2)+
    MOVE.B  #'P', (A2)+
    JSR     BITSIZE6
    BRA     PRINT_LINE
    
OP_EOR:
    MOVE.B  #'E', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'R', (A2)+
    JSR     BITSIZE6
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
    
    BRA     PRINT_LINE
    
OP_MULS:
    MOVE.B  #'M', (A2)+
    MOVE.B  #'U', (A2)+
    MOVE.B  #'L', (A2)+
    MOVE.B  #'S', (A2)+
    
    BRA     PRINT_LINE

OP_AND:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'N', (A2)+
    MOVE.B  #'D', (A2)+
    JSR     BITSIZE6
    BRA     PRINT_LINE
    
OP_ADD:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'D', (A2)+
    JSR     BITSIZE6
    BRA     PRINT_LINE

OP_ADDA:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'D', (A2)+
    MOVE.B  #'A', (A2)+
    JSR     BITSIZE8
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
    CMPI    #1, D6          ;D6 is set to 1 if we need to check for size
    JSR     BITSIZE6
    BRA     PRINT_LINE
    
OP_ASL:
    MOVE.B  #'A', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'L', (A2)+
    CMPI    #1, D6          ;D6 is set to 1 if we need to check for size
    JSR     BITSIZE6
    BRA     PRINT_LINE

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
    CMPI    #1, D6          ;D6 is set to 1 if we need to check for size
    JSR     BITSIZE6
    BRA     PRINT_LINE
    
OP_LSL:
    MOVE.B  #'L', (A2)+
    MOVE.B  #'S', (A2)+
    MOVE.B  #'L', (A2)+
    CMPI    #1, D6          ;D6 is set to 1 if we need to check for size
    JSR     BITSIZE6
    BRA     PRINT_LINE
    
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
    CMPI    #1, D6          ;D6 is set to 1 if we need to check for size
    JSR     BITSIZE6
    BRA     PRINT_LINE

OP_ROL:
    MOVE.B  #'R', (A2)+
    MOVE.B  #'O', (A2)+
    MOVE.B  #'L', (A2)+
    CMPI    #1, D6          ;D6 is set to 1 if we need to check for size
    JSR     BITSIZE6
    BRA     PRINT_LINE
    
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
    JMP     E_INPUT
    
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
