*-----------------------------------------------------------
* Title      :CSS422 Disassembler
* Written by :William T and
* Date       :February 12, 2020
* Description:Final Prjoect for CSS422
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA     STACK, SP   ;stack and stack pointer at $A0000

* Put program code here

    LEA     GREETING, A1    ;Loads GREETING into A1
    MOVE.B  #14, D0         ;loads the number 14 into data register D0
    TRAP    #15
    
FIND_ADDRESS:
    LEA     PROMPT1, A1     ;Prompts user to insert start address
    MOVE.B  #14, D0         ;loads the number 14 into data register D0
    TRAP    #15
    
    MOVE.B  #2, D0
    TRAP    #15             ;Takes user input, put in (A1)
    JSR     ATOI            ;Convert ASCII to integer
    MOVEQ   #0, D1          ;Clear D1 after use in ATOI
    CMP.B   #-1, D0
    BEQ     ERROR_HANDLER   ;Go to ERROR_HANDLER if D0 = -1
    MOVEA.L D3, A4          ;Stores decoded start address in A4
    MOVEQ   #0, D2
    MOVEQ   #0, D3
    MOVEQ   #0, D4          ;Clears registers D2, D3, and D4 after use in ATOI
    
    LEA     PROMPT2, A1     ;Prompts user to insert end address
    MOVE.B  #14, D0         ;Display
    TRAP    #15
    
    MOVE.B  #2, D0          ;Get user input, put in (A1)
    Trap    #15
    JSR     ATOI            ;Convert ASCII to integer
    CMP.B   #-1, D0
    BEQ     ERROR_HANDLER   ;Go to ERROR_HANDLER if D0 = -1
    MOVEA.L D3, A5          ;Stores decoded end address in A5
    MOVEQ   #0, D2
    MOVEQ   #0, D3
    MOVEQ   #0, D4          ;Clears registers D3 and D4 after use in ATOI
    
    CMPA.L  A4, A5
    BLT     ERROR_HANDLER   ;If A5 is less than A4, error
    
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
    CMPI.B  #0, D1
    BEQ     ERROR_HANDLER      ;No length, throw error
    
    MOVE.B  (A1)+, D2          ;Move A1 to D2
    CMPI    #36, D2            ;Checks if first symbol is $
    BNE     ERROR_HANDLER      ;If the first symbol is not $, throw error
    
STR_READ:
    ADDI    #1, D4             ;Increment D4
    CMP.B   D1, D4             ;If D4 is still smaller than D1, continue
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
    
*Calculate displacement in jump table
ATOI_DONE:
    MOVE.B  #14, D0      
    TRAP    #15             ;Print A1
    RTS                     ;Return to main

*-----------------------------------------------------------

*-----------------------------------------------------------
*ERROR_HANDLER: When an error occurs, prints error code
ERROR_HANDLER:
    LEA     MSG_ERROR, A1
    MOVE.B  #14, D0
    TRAP    #15
*-----------------------------------------------------------
    
END_PROG:
    SIMHALT             ; halt simulator




* Put variables and constants here
CR          EQU     $0D
LF          EQU     $0A
STACK       EQU     $A0000      ;Stack located at $A0000
nibble2     EQU     $0F00       ;Extract the 2nd nibble
nibble3     EQU     $00F0       ;Extract the 3rd nibble
nibble4     EQU     $000F       ;Extract the 4th nibble
GREETING    DC.B    'Welcome to the Disassembler', CR, LF, 0
PROMPT1     DC.B    'Please select start range of code to disassemble', CR, LF, 0
PROMPT2     DC.B    'Please select end range of code to disassemble', CR, LF, 0
MSG_ERROR   DC.B    'Error', CR, LF, 0
    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
© 2020 GitHub, Inc.
