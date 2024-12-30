
; Assembled with sbasm3 (https://www.sbprojects.net/sbasm/)
; All directives are specific to sbasm3, and may need to be changed for other assemblers

        .CR 6800               ; LOAD MC6800 CROSS OVERLAY
        .TF bf.exe,BIN         ; OUTPUT FILE IN BINARY FORMAT
        .OR $0200              ; START OF ASSEMBLY ADDRESS
        .LI   OFF                ; SWITCH OFF ASSEMBLY LISTING (EXCEPT ERRORS)
        .EF errors.err         ; USE errors.err as an error output file
        .SF SYMBOLS.SYM        ; CREATE SYMBOL FILE


; Main entry point ($0200)
;         Contains controller for the complete BrainF**k interpreter
;         all other subroutines are called (in)directly from this.

; OPTIMISE BY USING DEC LPSTR etc TO DECREMENT OR INCREMENT VALUES IN 16-BIT ADDRESSES

; DEBUG SYMBOLS LOOPTBL, TAPE, TP, INS, LPSTP

START   LDS     #$1FF          ; Stack below program
                               ; MUST be first line of code

        JSR     CLS            
        LDX     #BFMSG
        JSR     PUTMSG
        LDX     #BUILD 
        JSR     PUTMSG

REPL    LDX     #PROMPT
        JSR     PUTMSG
.IREPL
        JSR     INPCHR
        CMPA    EDITKEY       ; Test for 'E' to enter editor
        BEQ     .DOEDIT       ; If so, then enter editor
        CMPA    RUNPKEY       ; Test for 'R' to run the program
        BEQ     .RUNP         ; If so, then run the program
        JMP     .REPLR
.DOEDIT JSR     CLS            
        JSR     BFEDITOR
        JSR     CLS
.REPLR  JMP     REPL

.RUNP   LDX     #RUNNING
        JSR     PUTMSG
        LDX     #TAPE          ; Store initial tape pointer address in TP
CLRTP   STX     TP

; Need to reset tape storage to 256 zeros
        CLR     0,X
        INX
        CPX     #EOTAPE        ; Cycle until the end of the 256 bytes of tape
        BNE     CLRTP
        
        
        LDX     #TAPE          ; Re-store initial tape pointer address in TP
        STX     TP

        LDX     #INPUT         ; Store initial input pointer address in IP
        STX     IP
        

INTERPT                        ; Entry point of the main interpreter
        
        .IN phase1             ; Include the Phase 1 "preamble" (preparing the open/close bracket loop table)
 

PHASE2                         ; Phase 2 of the interpreter - start running the instructions
        CLR     INS            ; Clear the instruction counter
        LDX     #PROGRAM       ; Load program start address into the X-register and store in PC
        STX     PC

AROUND  LDX     PC 
        LDAA    0,X            ; Load current program instruction
        BEQ     DONE           ; If the end of the program has been reached, exit back to the REPL

        CMPA    DOT            ; 
        BEQ     OUTPUT         ; If it is an output instruction, skip to the OUTPUT

        CMPA    PLUS           ;
        BEQ     INCTPB         ; Is this an instruction to increment the byte at the tape pointer.

        CMPA    MINUS          ;
        BEQ     DECTPB         ; Is this an instruction to decrement the byte at the tape pointer.

        CMPA    GT             ;
        BEQ     INCTP          ; Is this an instruction to increment the tape pointer.

        CMPA    LT             ;
        BEQ     DECTP          ; Is this an instruction to decrement the tape pointer.

        CMPA    COMMA          ;
        BEQ     INP            ; Is this an instruction receive a byte of input.

        CMPA    OPEN 
        BEQ     ISOPEN         ; Is it an "open bracket" character i.e. "[" ?
        
        CMPA    CLOSE
        BEQ     IC             ; If not, is it a "close bracket" character i.e. "]" ...

        JMP     NEXT           ; Any other character is counted as a comment.
IC      BRA     ISCLOSE        ; To circumvent an out of range error.
DONE    JMP     REPL           ; End of program, so loop around for the next REPL

        .IN     language       ; Include language statement interpretations

INP     LDX     IP             ; Accept a byte of input from the input string
        LDAA    0,X            ; Get the byte of input pointed at by the input pointer
        INX                    ; Increment the input pointer
        STX     IP             ; Store the input pointer
        LDX     TP             ; Load the current value of the data pointer
        ; BRA     STASH        ; Falls through to STASH

STASH   STAA    0,X            ; Common stash routine for the value in the AccA to be stored
        BRA     NEXT           ; wherever X points


ISOPEN                         
                               ; If the byte at the data pointer is zero, then instead of moving the instruction 
                               ;     pointer forward to the next command, jump it forward to the command after the matching ] command.
        LDX     TP             ; Get the character at the current tape pointer
        LDAA    0,X            ; I THINK THIS BIT IS OK.
        CMPA    #0
        BEQ     OBINCIP
        BRA     NEXT           ; DOWN TO HERE

OBINCIP                         *******THIS NEEDS REWRITING - USE CLOSE BRACKET AS A MODEL ******
        
                                ; This bit finds the corresponding close bracket
        LDAA    INS             ; Current value of program counter (i.e. current open bracket)
        INCA                    ; Go to the next instruction
        LDX     #LOOPTBL        ; reload the value of the start of the loop table
OBLP    INX
        DECA
        BNE     OBLP
        LDAA    0,X
        DECA                    ; Reduce the instruction counter by 1 because "NEXT" will increment it again
        STAA    INS             ; Need to do this
                                
        LDX     #PROGRAM        ; Load the start of the program, then increment the PC until the prerequisite instruction is reached
        
RSTPRG  INX                     ; Need to reset the PC by 1 less than the instruction number to point to the instr.
        DECA                        ; after the close bracket.
        BNE     RSTPRG
        STX     PC              ; TRY THIS......

        BRA     NEXT            ; this increments the PC by 1, sending flow to the command after the corresponding close bracket

ISCLOSE                         ; If the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to 
                                ;     the next command, jump it back to the command after the matching [ command.
        LDX     TP              ; Get the character at the current tape pointer
        LDAA    0,X 
        CMPA    #0
        BNE     CBINCIP
        BRA     NEXT
        ; Move the instruction pointer to the command after the corresponding open bracket
CBINCIP
                                ; This bit gets the correct index of the loop table.
        LDAA    INS             ; Current value of instruction (i.e. current close bracket)
        LDX     #LOOPTBL        ; reload the value of the start of the loop table
CBLP    INX
        DECA
        BNE     CBLP
        INX                     ; Point at the next instruction in the loop table
        LDAA    0,X             ; AccA now contains the address of the corresponding open bracket

        LDX     #PROGRAM        ; Get the start of the program's instructions
CBLPX   INX
        DECA
        BNE     CBLPX
        DEX                     ; Program counter should not point to the instruction after the open bracket
        STX     PC


NEXT    LDX     PC             ; Increment program counter and store it before going back to the next
        INX                    ; instruction
        STX     PC
        INC     INS            ; Increment instruction counter
        JMP     AROUND         ; Go to the next instruction

ERR     JSR     PUTMSG         ; Output the stated error message
        JMP     REPL  

; Subroutines
        .IN editor
        .IN functions          ; Include specific functions from the library

; Constants and Variables
        .IN constants          ; Include constants
        .IN variables          ; Include variables for the program

.EN

