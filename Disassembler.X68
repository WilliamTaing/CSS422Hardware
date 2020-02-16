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
    
    LEA     PROMPT, A1      ;Prompts user to insert
    MOVE.B  #14, D0         ;loads the number 14 into data register D0
    TRAP    #15
    
    MOVE.B  #2, D0
    TRAP    #15             ;Takes user input, put in (A1)
    JSR     ATOI            ;Convert ASCII to integer
    MOVEQ   #0, D1          ;Clear D1 after use in ATOI
    CMP.B   #-1, D0         
    BEQ     ERROR_HANDLER   ;Go to ERROR_HANDLER if D0 = -1
    
    MOVE.B  #9, D0          ;loads the number 9 into data register D0
    TRAP    #15             ;terminates program
    BRA     END_PROG
    
    
    
    
*-----------------------------------------------------------
*ATOI: Converts and ASCII character to an integer
*A0 ASCII_TABLE
*A1 Holds String
*D1 Holds Length
*D2 Holds ASCII char to convert
*D3 Temp Variable
*D4 Counts loop
ATOI:
    CMPI.B  #0, D1
    BEQ     ERROR_HANDLER      ;No length, throw error
    
    LEA     ASCII_TABLE, A0    ;Load ASCII_TABLE to A0
    MOVE.B  (A1)+, D2          ;Move A1 to D2
    CMPI    #36, D2            ;Checks if first symbol is $
    BNE     ERROR_HANDLER      ;If the first symbol is not $, throw error
    
STR_READ:
    ADDI    #1, D4             ;Increment D4
    CMP.B   D1, D4             ;If D4 is still smaller than D1, continue
    BGT     ATOI_DONE
    MOVE.B  (A1)+, D2          ;Iterate through string
    CMPI    #48, D2
    BLT     ERROR_HANDLER      ;If numbers are not within range (>48) throw error
    CMPI    #70, D2
    BGT     ERROR_HANDLER      ;If numbers are not within range (<70) throw error
       
*Calculate displacement in jump table
ATOI_DONE:
    MOVE.B  #14, D0      
    TRAP    #15             ;Print A1
    RTS     
*-----------------------------------------------------------
ASCII_TABLE:
    JMP     ASCII0              ;0
    JMP     ASCII1              ;1
    JMP     ASCII2              ;2
    JMP     ASCII3              ;3
    JMP     ASCII4              ;4
    JMP     ASCII5              ;5
    JMP     ASCII6              ;6
    JMP     ASCII7              ;7
    JMP     ASCII8              ;8
    JMP     ASCII9              ;9
    JMP     ASCIIA              ;A
    JMP     ASCIIB              ;B
    JMP     ASCIIC              ;C
    JMP     ASCIID              ;D
    JMP     ASCIIE              ;E
    JMP     ASCIIF              ;F
    JMP     ASCII$              ;$
    
ASCII0:
    MOVE.B  #0, D3
    BRA STR_READ
ASCII1:
    MOVE.B  #1, D3
    BRA STR_READ
ASCII2:
    MOVE.B  #2, D3
    BRA STR_READ
ASCII3:
    MOVE.B  #3, D3
    BRA STR_READ
ASCII4:
    MOVE.B  #4, D3
    BRA STR_READ
ASCII5:
    MOVE.B  #5, D3
    BRA STR_READ
ASCII6:
    MOVE.B  #6, D3
    BRA STR_READ
ASCII7:
    MOVEQ.L  #7, D3
    BRA STR_READ
ASCII8:
    MOVEQ.L  #8, D3
    BRA STR_READ
ASCII9:
    MOVEQ.L  #9, D3
    BRA STR_READ
ASCIIA:
    MOVEQ.L  #10, D3
    BRA STR_READ
ASCIIB:
    MOVEQ.L  #11, D3
    BRA STR_READ
ASCIIC:
    MOVEQ.L  #12, D3
    BRA STR_READ
ASCIID:
    MOVEQ.L  #13, D3
    BRA STR_READ
ASCIIE:
    MOVEQ.L  #14, D3
    BRA STR_READ
ASCIIF:
    MOVEQ.L  #15, D3
    BRA STR_READ
ASCII$:
    BRA STR_READ
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
PROMPT      DC.B    'Please select range of code to disassemble (Start)', CR, LF, 0
MSG_ERROR   DC.B    'Error', CR, LF, 0
    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
