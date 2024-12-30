; Program Variables

SCRTCHA  .DA     1             ; Space for AccA
SCRTCHB  .DA     1             ; Space for AccB
SCRTCHX  .DA     1             ; Space for X register

PC       .DA     1             ; Program counter
TP       .DA     1             ; Tape pointer
IP       .DA     1             ; Input pointer
INS      .DA     1             ; Instruction counter (within program - 8-bit number)

LPSTP    .DA     2             ; Loop Stack Pointer
BK       .DA     1             ; Pointer in program in phase 1
LBI      .DA     2             ; Start of the loop indicated by the close bracket

PRGDAT   .BS     1             ; Will comtain 0 for program display, 1 for data display

; HELLO WORLD PROGRAM
;PROGRAM  .AZ     />++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+./

;PROGRAM  .AZ     />+++++++++++++++++++++++++++++++++.>++>>>[.-<]/
;PROGRAM  .AZ     /+++++>+++[<+>-]/
;PROGRAM  .AZ     />>>>>>>>>>/
;PROGRAM  .AZ     /+.+.+./
PROGRAM   .AZ     /+++++[>++++<-]/ ; fill second cell up to 20.
FILLERP1 .BS     242,0    ; Fill with 0's

INPUT     .AS     /123/
FILLERD1   .BS     253,0    ; Fill with 0's


;INPUT     .BS     $FF,0    ; Fill with 1's

SOURCE    .BS    2    ; Define 2 byte SOURCE address
DEST      .BS    2    ; Define 2 byte DESTINATION address
    