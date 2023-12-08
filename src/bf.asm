
; Assembled with sbasm3 (https://www.sbprojects.net/sbasm/)
; All directives are specific to sbasm3, and may need to be changed for other assemblers

        .CR 6800               ; LOAD MC6800 CROSS OVERLAY
        .TF bf.exe,BIN         ; OUTPUT FILE IN BINARY FORMAT
        .OR $0200              ; START OF ASSEMBLY ADDRESS
        .LI OFF                ; SWITCH OFF ASSEMBLY LISTING (EXCEPT ERRORS)
        .SF SYMBOLS.SYM        ; CREATE SYMBOL FILE

; Main entry point
;         Contains controller for the complete BrainF**k interpreter
;         all other subroutines are called (in)directly from this.

START   LDS     #$1FF          ; Stack below program
                               ; MUST be first line of code


        JSR     CLS            
        LDX     #BFMSG
        JSR     PUTMSG
        LDX     #BUILD 
        JSR     PUTMSG
REPL    LDX     #PROMPT
        JSR     PUTMSG
        JSR     INPCHR
        
        LDX     #PROGRAM       ; Store program start address in PC
        STX     PC

        LDX     #TAPE          ; Store initial data pointer address in TP
        STX     DP

INTERPT                        ; Entry point of the main interpreter
        
AROUND  LDX     PC 
        LDAA    0,X            ; Load current program instruction
        BEQ     DONE           ; If the end of the program has been reached, exit back to the REPL

        CMPA    DOT            ; 
        BEQ     OUTPUT         ; If it is an output instruction, skip to the OUTPUT

        CMPA    PLUS           ;
        BEQ     INCDP          ; Is this an instruction to increment the byte at the data pointer.

        CMPA    MINUS          ;
        BEQ     DECDP          ; Is this an instruction to decrement the byte at the data pointer.

        BRA     NEXT

DONE    JMP     REPL           ; End of program, so loop around for the next REPL

OUTPUT  LDX     DP             ; Output the character at the current data pointer
        LDAA    0,X 
        JSR     PUTCHR
        BRA     NEXT 

INCDP   LDX     DP             ; Increment the value at the current data pointer
        LDAA    0,X
        INCA    
        STAA    0,X
        BRA     NEXT

DECDP   LDX     DP             ; Decrement the value at the current data pointer
        LDAA    0,X
        DECA    
        STAA    0,X
        BRA     NEXT
NEXT
        LDX     PC             ; Increment program counter and store it before going back to the next
        INX                    ; instruction
        STX     PC
        BRA     AROUND         ; Go to the next instruction

; Subroutines
        .IN library            ; Include library routines
        
; Constants and Variables
        .IN constants          ; Include constants
        .IN variables          ; Include variables for the program

.EN

