; Phase 1 :
;         Create the loop index tables for later processing by the [ and ] instructions


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

                               
                               ; DEFINITELY GOOD TO HERE.....
        
                               ; Remember, AccB contains LBI
                               ; loop_table[loop_beginning_index] = bk
CLB2    LDAA    BK             ; seems good till here
        LDX     #LOOPTBL       ; Reset the loop table value
        
LOOPA   INX
        DECB
        BNE     LOOPA
        STAA    0,X 
        
        ; loop_table[bk] = loop_beginning_index
        LDAA    BK
        LDAB    LBI
        LDX     #LOOPTBL
LOOPB   INX
        DECA
        BNE     LOOPB
        STAB    0,X 
                               ; I THINK WE ARE GOOD TO HERE..... :-)
                              

NXTP1   INC     BK
        LDX     PC             ; Increment program counter and store it before going back to the next
        INX                    ; instruction
        STX     PC

        BRA     P1LOOP

