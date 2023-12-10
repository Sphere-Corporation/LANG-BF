
; Program Constants

; Keycodes

ENTER   .AS     #$0D           ; ENTER Key
ESCCHR  .AS     #$1B           ; ESCape Key
HELPU   .AS     #$48           ; Upper case "H"
RESET   .AS     #$53           ; "S" Character

; Language characters

DOT     .AS     #$2E           ; Output the byte at the data pointer.
PLUS    .AS     #$2B	       ; Increment the byte at the data pointer by one.
MINUS   .AS     #$2D           ; Decrement the byte at the data pointer by one.
GT      .AS     #$3E	       ; Increment the data pointer by one (to point to the next cell to the right).
LT      .AS     #$3C	       ; Decrement the data pointer by one (to point to the next cell to the left).


COMMA   .AS     #$2C           ; Accept one byte of input, storing its value in the byte at the data pointer.
OPEN    .AS     #$5B	       ; If the byte at the data pointer is zero, then instead of moving the instruction 
                               ;     pointer forward to the next command, jump it forward to the command after the matching ] command.
CLOSE   .AS     #$5D	       ; If the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to 
                               ;     the next command, jump it back to the command after the matching [ command.


; Strings
BFMSG   .AZ     /BRAINF**K FOR SPHERE-1/,#$0D  ; Main Banner
PROMPT  .AZ     #$0D,/$ /                      ; Prompt

        .IN firmware                     ; Include firmware constants
        .IN build                        ; Include dynamic Build information
