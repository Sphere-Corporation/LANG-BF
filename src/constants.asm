
; Program Constants

; Keycodes

ENTER   .AS     #$0D           ; ENTER Key
ESCCHR  .AS     #$1B           ; ESCape Key
HELPU   .AS     #$48           ; Upper case "H"
RESET   .AS     #$53           ; "S" Character

; Strings
BFMSG   .AZ     /BRAINF**K INTERPRETER/,#$0D,/>/ ; Main Message

        .IN firmware                     ; Include firmware constants
        .IN build                        ; Include dynamic Build information
