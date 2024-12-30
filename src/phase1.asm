; Phase 1 :
;         Check for an overlength program
;         Create the loop index tables for later processing by the [ and ] instructions

        LDX     #PROGRAM      ; Get the start location of the program
        DEX                   ; Reduce it by 1
        CLRB                  ; Clear AccB
NXTC    INX                   ; Increment X register by 1
        LDAA    0,X           ; Load AccA with the value pointed at by the X register
        CMPA    #0            ; Is it beyond the end of the program ?
        BEQ     PHASE1        ; If it is, then go to the start of Phase 1 
        INCB                  ; If not then increment the AccB 
        CMPB    MAXPROG       ; Have we reached the upper limit of the allowable program length ?
        BNE     NXTC          ; If not, cycle back around
        LDX     #E001         ; If we have then load the error code 
        JMP     ERR           ; Display the error code

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

CLOSEB  LDX     LPSTP          ; Get the address of the current internal stack pointer
        DEX                    ; Decrement the stack pointer
        LDAB    0,X            ; Load into AccB the value at the current stack pointer
        STX     LPSTP          ; Store the stack pointer
        STAB    LBI            ; Store the position in LBI

                               ; At this point, AccB contains LBI
                               ; loop_table[LBI] = bk
CLB2    LDAA    BK             
        LDX     #LOOPTBL       ; Reset the loop table value
        
LOOPA   INX
        DECB
        BNE     LOOPA
        STAA    0,X 
        
                               ; Store the beginning of the loop in the "end of loop" location
        LDAA    BK
        LDAB    LBI
        LDX     #LOOPTBL
LOOPB   INX
        DECA
        BNE     LOOPB
        STAB    0,X                               

NXTP1   INC     BK
        LDX     PC             ; Increment program counter and store it before going back to the next
        INX                    ; instruction
        STX     PC
        BRA     P1LOOP

