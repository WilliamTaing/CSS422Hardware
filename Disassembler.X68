*-----------------------------------------------------------
* Title      :CSS422 Disassembler
* Written by :William T and
* Date       :February 12, 2020
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
