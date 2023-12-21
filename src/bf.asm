
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

RUNP
        LDX     #TAPE          ; Store initial tape pointer address in TP
        STX     TP

        LDX     #INPUT         ; Store initial input pointer address in IP
        STX     IP
        


INTERPT                        ; Entry point of the main interpreter
        
        LDX     #PROGRAM       ; Load program start address into the X-register
        
        
PHASE1  



PHASE2                         ; Phase 2 of the interpreter - start running the instructions

        LDX     #PROGRAM       ; Load program start address into the X-register and store in PC
        STX     PC

AROUND  LDX     PC 
        LDAA    0,X            ; Load current program instruction
        BEQ     DONE           ; If the end of the program has been reached, exit back to the REPL

        CMPA    DOT            ; 
        BEQ     OUTPUT         ; If it is an output instruction, skip to the OUTPUT

        CMPA    PLUS           ;
        BEQ     INCBTP         ; Is this an instruction to increment the byte at the tape pointer.

        CMPA    MINUS          ;
        BEQ     DECBTP         ; Is this an instruction to decrement the byte at the tape pointer.

        CMPA    GT             ;
        BEQ     INCTP          ; Is this an instruction to increment the tape pointer.

        CMPA    LT             ;
        BEQ     DECTP          ; Is this an instruction to decrement the tape pointer.

        CMPA    COMMA          ;
        BEQ     INP            ; Is this an instruction receive a byte of input.

        CMPA    OPEN 
        BEQ     ISOPEN         ; Is it an "open bracket" character i.e. "[" ?
        
        CMPA    CLOSE
        BEQ     ISCLOSE        ; If not, is it a "close bracket" character i.e. "]" ...

        BRA     NEXT           ; Any other character is counted as a comment.

DONE    JMP     REPL           ; End of program, so loop around for the next REPL

OUTPUT  LDX     TP             ; Output the character at the current tape pointer
        LDAA    0,X 
        JSR     PUTCHR
        BRA     NEXT 

INCBTP  LDX     TP             ; Increment the byte at the current tape pointer
        LDAA    0,X
        INCA
        BRA     STASH    

DECBTP  LDX     TP             ; Decrement the byte at the current tape pointer
        LDAA    0,X
        DECA
        BRA     STASH

INCTP   LDX     TP             ; Increment the current tape pointer
        INX
        STX     TP
        BRA     NEXT

DECTP   LDX     TP             ; Increment the current tape pointer
        DEX
        STX     TP
        BRA     NEXT

INP     LDX     IP             ; Accept a byte of input from the input string
        LDAA    0,X            ; Get the byte of input pointed at by the input pointer
        INX                    ; Increment the input pointer
        STX     IP             ; Store the input pointer
        LDX     TP             ; Load the current value of the data pointer
        ; BRA     STASH        ; Falls through to STASH

STASH   STAA    0,X            ; Common stash routine for the value in the AccA to be stored
        BRA     NEXT           ; wherever X points

ISOPEN  STX     SCRTCHX        ; Store current value of program counter in SCRTCHX
        LDX     TP             ; Functionality for an open bracket
        LDAA    0,X            ; Test to see if the value at the tape pointer cell is zero. 
        BNE     NEXT           ; If it is non-zero, move on to the next instruction
                               ; If it IS zero, 
        CLR     BRACKETS       ; Store 1 in "Brackets"
        INC     BRACKETS  

        LDX     SCRTCHX              ; loop:
OBLOOP  LDAA    BRACKETS             ; if brackets == 0, jump to nextinstr
        BEQ     GONEXT
        INX                             ; increment X
        LDAA    0,X                     ; Load current program instruction
        CMPA    OPEN
        BEQ     ADDBRK                  ; if instruction is "[", increment "BRACKETS" at "ADDBRK"
        CMPA    CLOSE                                                   
        BEQ     SUBBRK                  ; if instruction is "]", decrement "BRACKETS" at "SUBBRK"

ADDBRK  INC     BRACKETS                    ;       add 1 to "Brackets"
        BRA     OBLOOP
                                        ; 
SUBBRK  DEC     BRACKETS
        BRA     OBLOOP

GONEXT  INX
        STX PC
        BRA     NEXT

ISCLOSE 
        BRA     NEXT


NEXT    LDX     PC             ; Increment program counter and store it before going back to the next
        INX                    ; instruction
        STX     PC
        JMP     AROUND         ; Go to the next instruction





; Subroutines
        .IN library            ; Include library routines
        
; Constants and Variables
        .IN constants          ; Include constants
        .IN variables          ; Include variables for the program

.EN

