
; Assembled with sbasm3 (https://www.sbprojects.net/sbasm/)
; All directives are specific to sbasm3, and may need to be changed for other assemblers

        .CR 6800               ; LOAD MC6800 CROSS OVERLAY
        .TF bf.exe,BIN         ; OUTPUT FILE IN BINARY FORMAT
        .OR $0200              ; START OF ASSEMBLY ADDRESS
        .LI   ON,MON,CON                ; SWITCH OFF ASSEMBLY LISTING (EXCEPT ERRORS)
        .SF SYMBOLS.SYM        ; CREATE SYMBOL FILE

PROGRAM  .AZ     /+.+.+./
         .NO     $300,$00        ; New origin - fill interim space with 0 to allow for program storage

; Main entry point ($0300)
;         Contains controller for the complete BrainF**k interpreter
;         all other subroutines are called (in)directly from this.

; OPTIMISE BY USING DEC LPSTR etc TO DECREMENT OR INCREMENT VALUES IN 16-BIT ADDRESSES

START   LDS     #$1FF          ; Stack below program
                               ; MUST be first line of code

;; TRIAL OF EDITOR

BUFADR  .EQU    $000C 
BUFEND  .EQU    $000E 

EDITOR  .EQU    $FC67
REEDIT  .EQU    $FC73

PRGBUFS .EQU    $0600
PRGBUFE .EQU    $0700

        LDX     #PROGRAM
        STX     BUFADR
        LDX     #PROGRAM + 256
        STX     BUFEND
        LDAA    #1
        JSR     EDITOR

;;        LDAA    1
;;        JSR     REEDIT
;; END OF TRIAL

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
CLRTP   ;STX     TP

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
        BEQ     ISCLOSE        ; If not, is it a "close bracket" character i.e. "]" ...

        JMP     NEXT           ; Any other character is counted as a comment.

DONE    JMP     REPL           ; End of program, so loop around for the next REPL

OUTPUT  LDX     TP             ; Output the character at the current tape pointer
        LDAA    0,X 
        JSR     PUTCHR
        JMP     NEXT 

INCTPB  LDX     TP             ; Increment the byte at the current tape pointer
        LDAA    0,X
        INCA
        BRA     STASH    

DECTPB  LDX     TP             ; Decrement the byte at the current tape pointer
        LDAA    0,X
        DECA
        BRA     STASH


INCTP   LDX     TP             ; Increment the current tape pointer
        INX                    
        CPX     #EOTAPE        ; Have we exceeded the tape length ?
        BEQ     TAP2LNG
        STX     TP      
        BRA     NEXT

TAP2LNG LDX     #E002          ; Show error message
        JMP     ERR

DECTP   LDX     TP             ; Decrement the current tape pointer
        CPX     #TAPE          ; Is the tape pointer at the start of the tape?
        BEQ     TAP2SHT
        DEX                    
        STX     TP
        BRA     NEXT

TAP2SHT LDX     #E003          ; Show error message
        JMP     ERR

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
        LDAA    0,X 
        CMPA    #0
        BEQ     OBINCIP
        BRA     NEXT
        ; Move the instruction pointer to the command after the corresponding close bracket
OBINCIP                         *******THIS NEEDS REWRITING - USE CLOSE BRACKET AS A MODEL ******
                                ; This bit finds the corresponding close bracket
        LDAA    INS             ; Current value of program counter (i.e. current open bracket)
        LDX     #LOOPTBL        ; reload the value of the start of the loop table
OBLP    INX
        DECA
        BNE     OBLP
        LDAA    0,X
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
        LDAA    0,X             ; AccB now contains the address of the corresponding open bracket
        ; CLOSE BRACKET OK TILL HERE

        LDX     #PROGRAM        ; Get the start of the program's instructions
CBLPX   INX
        DECA
        BNE     CBLPX
        DEX                        ; Program counter should not point to the instruction after the open bracket
TST     STX     PC
        

                                ; CAN PROBABLY LEAVE THIS OUT WHEN FULLY DEBUGGED - ONLY A DROP THRU - 
                                ; WASTES 3 BYTES
        ; test program' instruction counter i.e. X reg and PC should be pointing to 0F10 - next instruction should be a #$3E
        ; maybe even do a JMP AROUND ?????

NEXT    LDX     PC             ; Increment program counter and store it before going back to the next
        INX                    ; instruction
        STX     PC
        INC     INS            ; Increment instruction counter
        JMP     AROUND         ; Go to the next instruction

ERR     JSR     PUTMSG         ; Output the stated error message
        JMP     REPL  

; Subroutines
        .IN library            ; Include library routines
        
; Constants and Variables
        .IN constants          ; Include constants
        .IN variables          ; Include variables for the program

.EN

