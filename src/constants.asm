
; Program Constants

; Keycodes

ENTER   .AS     #$0D           ; ENTER Key
ESCCHR  .AS     #$1B           ; ESCape Key

; Language characters

PLUS    .AS     #$2B	       ; Increment the byte at the data pointer by one.
COMMA   .AS     #$2C           ; Accept one byte of input, storing its value in the byte at the data pointer.
MINUS   .AS     #$2D           ; Decrement the byte at the data pointer by one.
DOT     .AS     #$2E           ; Output the byte at the data pointer.
LT      .AS     #$3C	       ; Decrement the data pointer by one (to point to the next cell to the left).
GT      .AS     #$3E	       ; Increment the data pointer by one (to point to the next cell to the right).
; TO DO
OPEN    .AS     #$5B	       ; If the byte at the data pointer is zero, then instead of moving the instruction 
                               ;     pointer forward to the next command, jump it forward to the command after the matching ] command.
CLOSE   .AS     #$5D	       ; If the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to 
                               ;     the next command, jump it back to the command after the matching [ command.


; Strings
BFMSG   .AZ     /BRAINF**K FOR SPHERE-1/,#$0D  ; Main Banner
PROMPT  .AZ     #$0D,/$ /                      ; Prompt

        .IN firmware                     ; Include firmware constants
        .IN build                        ; Include dynamic Build information
