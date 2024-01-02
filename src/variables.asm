; Program Variables
;SCRTCHA  .DA     1             ; Space for AccA
;SCRTCHB  .DA     1             ; Space for AccB
;SCRTCHX  .DA     2             ; Space for X register

PC       .DA     1             ; Program counter
TP       .DA     1             ; Tape pointer
IP       .DA     1             ; Input pointer

LPSTP    .DA     2             ; Loop Stack Pointer
BK       .DA     1             ; Pointer in program in phase 1
LBI      .DA     2             ; Start of the loop indicated by the close bracket

;PROGRAM  .AZ     />++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+./
PROGRAM  .AZ     /[[[.>.]]]/ 
TAPE     .AZ     /ABCDEFG/
INPUT    .AZ     /123/

