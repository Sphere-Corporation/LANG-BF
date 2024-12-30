
; Program Constants

; Graphic Characters

CURSOR  .AS     #$FF           ; Cursor Symbol
EDBNDY  .AS     #$FF           ; Editor Boundary Symbol

; Limits

MAXPROG .AS     #$FF           ; Maximum length of the program

; Error codes

E001    .AZ     /E001/
E002    .AZ     /E002/
E003    .AZ     /E003/

; Keycodes

ENTER   .AS     #$0D           ; ENTER Key
ESCCHR  .AS     #$1B           ; ESCape Key
EDITKEY .AS     #$45           ; 'E' to enter editor
RUNPKEY .AS     #$52           ; 'R' to run program
DATAKEY .AS     #$09           ; CTRL 'I' to toggle program/data in editor

CRIGHT  .AS     #$12           ; Arrow Right
CLEFT   .AS     #$14           ; Arrow Left
CUP     .AS     #$11           ; Arrow Up
CDOWN   .AS     #$13           ; Arrow Down

; Language characters

PLUS    .AS     #$2B	       ; Increment the byte at the tape pointer by one.
COMMA   .AS     #$2C           ; Accept one byte of input, storing its value in the byte at the tape pointer.
MINUS   .AS     #$2D           ; Decrement the byte at the tape pointer by one.
DOT     .AS     #$2E           ; Output the byte at the tape pointer.
LT      .AS     #$3C	       ; Decrement the tape pointer by one (to point to the next cell to the left).
GT      .AS     #$3E	       ; Increment the tape pointer by one (to point to the next cell to the right).
OPEN    .AS     #$5B	       ; If the byte at the tape pointer is zero, then instead of moving the instruction 
                               ;     pointer forward to the next command, jump it forward to the command after the matching ] command.
CLOSE   .AS     #$5D	       ; If the byte at the tape pointer is nonzero, then instead of moving the instruction pointer forward to 
                               ;     the next command, jump it back to the command after the matching [ command.

; Memory Locations

STACK   .EQU     $0E00         ; Start of internal stack
LOOPTBL .EQU     $0EFF         ; Loop table (one less than the value required)
TAPE    .EQU     $09FF         ; Start address of tape storage
EOTAPE  .EQU     $0AFE         ; End address of tape storage

; Strings

BFMSG   .AZ     /BRAINF**K FOR SPHERE-1/,#$0D  ; Main Banner
PROMPT  .AZ     #$0D,/$ /                      ; Prompt

        .IN firmware                     ; Include firmware constants
        .IN build                        ; Include dynamic Build information

RUNNING .AZ /RUNNING.../