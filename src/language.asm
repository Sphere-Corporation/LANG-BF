; Language interpretation functions

OUTPUT  LDX     TP             ; Output the character at the current tape pointer
        LDAA    0,X 
        JSR     PUTCHR
        JMP     NEXT 

;===========

INCTPB  LDX     TP             ; Increment the byte at the current tape pointer
        LDAA    0,X
        INCA
        BRA     STASH

;===========
    

DECTPB  LDX     TP             ; Decrement the byte at the current tape pointer
        LDAA    0,X
        DECA
        BRA     STASH


;===========

INCTP   LDX     TP             ; Increment the current tape pointer
        INX                    
        CPX     #EOTAPE        ; Have we exceeded the tape length ?
        BEQ     TAP2LNG
        STX     TP      
        BRA     NEXT

TAP2LNG LDX     #E002          ; Show error message
        JMP     ERR


;===========

DECTP   LDX     TP             ; Decrement the current tape pointer
        CPX     #TAPE          ; Is the tape pointer at the start of the tape?
        BEQ     TAP2SHT
        DEX                    
        STX     TP
        BRA     NEXT

TAP2SHT LDX     #E003          ; Show error message
        JMP     ERR