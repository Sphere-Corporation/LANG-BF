; Program Variables

PC       .DA     1             ; Program counter
TP       .DA     1             ; Tape pointer
IP       .DA     1             ; Input pointer
INS      .DA     1             ; Instruction counter (within program - 8-bit number)

LPSTP    .DA     2             ; Loop Stack Pointer
BK       .DA     1             ; Pointer in program in phase 1
LBI      .DA     2             ; Start of the loop indicated by the close bracket

;PROGRAM  .AZ     />++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+./
;PROGRAM  .AZ     />+++++++++++++++++++++++++++++++++.>++>>>[.-<]/
;PROGRAM  .AZ     /+++++>+++[<+>-]/
PROGRAM  .AZ     />>>>>>>>>>/

INPUT    .AZ     /123/



        

