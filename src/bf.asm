
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

; OPTIMISE BY USING DEC LPSTR etc TO DECREMENT OR INCREMENT VALUES IN 16-BIT ADDRESSES

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
        

PHASE1  
        CLR     BK             ; Clear the instruction counter for Phase 1
        INC     BK             ; Increment it by 1
        LDX     #STACK         ; Reset the internal stack pointer 
        STX     LPSTP          ; to the base of the stack



        LDX     #PROGRAM       ; Load program start address into the X-register and store in PC
        STX     PC
P1LOOP  LDX     PC 
        LDAA    0,X            ; Load current program instruction
        BEQ     PHASE2         ; End of program reached
        CMPA    OPEN
        BEQ     OPENB          ; If this is an open bracket, pop the location on to the internal stack
        CMPA    CLOSE          
        BEQ     CLOSEB         ; If this is a close bracket, locate the previous open bracket 
        BRA     NXTP1

OPENB   LDAA    BK             ; Load the current bracket position into AccA
        LDX     LPSTP          ; Get the address of the current internal stack pointer
        STAA    0,X            ; Store the current open bracket position in the stack
        INX                    ; Increment the stack pointer
        STX     LPSTP
        BRA     NXTP1 

                               ; CLOSE BRACKET STUFF
CLOSEB  LDX     LPSTP          ; MANAGEMENT OF THE LPSTP STACK IS FINE.....
        DEX
        LDAB    0,X             
        STX     LPSTP          ;
        STAB    LBI            ; loop_beginning_index is now stored

                               
                               ; DEFINATELY GOOD TO HERE.....
        
                               ; Remember, AccB contains LBI
                               ; loop_table[loop_beginning_index] = bk
CLB2    LDAA    BK             ; seems good till here
        LDX     #LOOPTBL       ; Reset the loop table value
        
LOOPA   INX
        DECB
        BNE     LOOPA
        STAA    0,X 
        
        ; loop_table[bk] = loop_beginning_index
        LDAA    BK
        LDAB    LBI
        LDX     #LOOPTBL
LOOPB   INX
        DECA
        BNE     LOOPB
        STAB    0,X 
                               ; I THINK WE ARE GOOD TO HERE..... :-)
                              

NXTP1   INC     BK
        LDX     PC             ; Increment program counter and store it before going back to the next
        INX                    ; instruction
        STX     PC

        BRA     P1LOOP


; contents:

; STACK         E00   4       010203??
; LOOPTBL       F00   4       030201??

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


ISOPEN                         ; NOT DEBUGGED YET - COMMENTED OUT FOR NOW.
                               ; If the byte at the data pointer is zero, then instead of moving the instruction 
                               ;     pointer forward to the next command, jump it forward to the command after the matching ] command.
        ;LDX     TP             ; Get the character at the current tape pointer
        ;LDAA    0,X 
        ;BEQ     OBINCIP
        ;BRA  NEXT
        ; Move the instruction pointer to the command after the corresponding close bracket

ISCLOSE

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

