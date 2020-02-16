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
    
    
    
    
    
*-----------------------------------------------------------
*ATOI: Converts and ASCII character to an integer
ATOI:
    MOVE.B  (A1)+, D2    ;Move A1 to D1
    MOVE.B  #14, D0      
    TRAP    #15          ;Print A1

    SIMHALT             ; halt simulator

*-----------------------------------------------------------
*ERROR_HANDLER: When an error occurs, prints error code
ERROR_HANDLER:
    LEA     MSG_ERROR, A1
    MOVE.B  #14, D0
    TRAP    #15


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
