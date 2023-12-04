
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

        LDS     #$1FF          ; Stack below program
                               ; MUST be first line of code
        JSR     CLS            
        LDX     #BFMSG
        JSR     PUTMSG
        JSR     INPCHR

LOOP    JMP     LOOP


; Subroutines
        .IN library            ; Include library routines
        
; Constants and Variables
        .IN constants          ; Include constants
        .IN variables          ; Include variables for the program

.EN

