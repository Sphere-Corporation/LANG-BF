; Program Variables
SCRTCHA  .DA     1             ; Space for AccA
SCRTCHB  .DA     1             ; Space for AccB
SCRTCHX  .DA     1             ; Space for X register

PC       .DA     2             ; Program counter
TP       .DA     2             ; Tape pointer
IP       .DA     2             ; Input pointer

;PROGRAM  .AZ     />++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+./
PROGRAM  .AZ     /.>.>.>.>./
TAPE     .AZ     /ABCDEFG/
INPUT    .AZ     /1/
