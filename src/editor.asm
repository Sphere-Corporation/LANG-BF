; Editor :
;         Small 8-line editor 

BFEDITOR

; Initialise control variables
        CLR     PRGDAT        ; Set PRGDAT to zero (indicating program in editor)
; Draw Editor surround
        JSR     .BOX
; Load program in from memory (default behaviour)
        JSR     .LDPRG
        JSR     .RSTCRS        ; Reset cursor to start of editor

; Main editor loop

.CHRLP  JSR     GETCHR        ; Get character

.T1     CMPA    ESCCHR        ; Test for ESCape
        BNE     .CSRTST       ; If ESCape, then quit editor
        JMP     .QUIT
.CSRTST                       ; Check for cursor keys being pressed
        CMPA    CRIGHT           
        BEQ     .ARRR         ; Arrow Right
        CMPA    CLEFT
        BEQ     .ARRL         ; Arrow Left
        CMPA    CUP
        BEQ     .ARRU         ; Arrow Up
        CMPA    CDOWN
        BEQ     .ARRD         ; Arrow Down

        CMPA    DATAKEY       ; If CTRL-I then toggle between program and data
        BNE     .T3
        TST     PRGDAT        ; Test PRGDAT for a zero
        BNE     .T2A          ; Determine which to display - data or program
        JSR     .SVPRG
        JSR     .LDDATA
        BRA     .CHRLP
.T2A    JSR     .SVDATA
        JSR     .LDPRG
        BRA     .CHRLP

; Right cursor
.ARRR   LDX     CSRPTR        ; Load the 16-bit value of the current cursor pointer
        CPX     ENDSCR
        BEQ     .RT1
        
        INX                   ; Increment it, and store it
        STX     CSRPTR
        BRA     .CHRLP
.RT1    LDX     STTSCR
        STX     CSRPTR
        BRA     .CHRLP

; Left cursor
.ARRL   LDX     CSRPTR        ; Load the 16-bit value of the current cursor pointer
        CPX     STTSCR
        BEQ     .LT1
        
        DEX                   ; Decrement it, and store it
        STX     CSRPTR
        BRA     .CHRLP
.LT1    LDX     ENDSCR
        STX     CSRPTR
        BRA     .CHRLP


.ARRU   LDAA    CLINE        ; Get the line of the cursor
        BEQ     .AULP        ; If it's zero, then don't do arrow up....

        JSR     SUB32
        DEC     CLINE        ; Decrement cursor line
.AULP   BRA     .CHRLP

.ARRD   LDAA    CLINE
        CMPA    #7           ; Compare with the bottom line of the editor window
        BEQ     .ADLP        ; Don't move the cursor down if no more room.
        JSR     ADD32
        INC     CLINE        ; Increment cursor line

.ADLP   JMP     .CHRLP

.T3     TST     PRGDAT
        BNE     .VIEW

        CMPA    PLUS          ; Is this a valid BF character ?
        BEQ     .VIEW         ; If so, then echo it to the screen
        CMPA    COMMA
        BEQ     .VIEW
        CMPA    MINUS
        BEQ     .VIEW
        CMPA    DOT
        BEQ     .VIEW
        CMPA    LT
        BEQ     .VIEW
        CMPA    GT
        BEQ     .VIEW
        CMPA    OPEN
        BEQ     .VIEW
        CMPA    CLOSE
        BEQ     .VIEW
        JMP     .CHRLP

.VIEW   
        LDX     CSRPTR        ; Load the 16-bit value of the current cursor pointer
        DEX
        CPX     ENDSCR        ; Are we at the end of the editor ?
        BNE     .VEND         ; If not, loop around again
        JMP     .CHRLP
.VEND   JSR     PUTCHR        ; Store character on screen
        JMP     .CHRLP
                
.QUIT   
        TST     PRGDAT        ; Test PRGDAT for a zero
        BNE     .TA1          ; Determine which to save - data or program
        JSR     .SVDATA
        BRA     .OUT
.TA1    JSR     .LDPRG

.OUT    RTS                   ; Return to the calling program


; Prepare to load data into the editor from memory
.LDDATA CLR     PRGDAT
        INC     PRGDAT
        LDX     #INPUT
        BRA     .LDCOM
; Prepare to load program into the editor from memory
.LDPRG  CLR     PRGDAT
        LDX     #PROGRAM
; Will fall through to common components        
; Common components of loading program/data
.LDCOM  STX     CPYSRC          
        LDX     #$E080
        STX     CPYDST
        JSR     COPYSTR
        JSR     .RSTCRS         ; Reset cursor to start
        JSR     .SWPLBL         ; Change label between "PROGRAM" and "DATA"
        CLR     CLINE         ; Set cursor line to be zero
        RTS

; Prepare to save data to memory from the editor
.SVDATA LDX     #INPUT
        BRA     .SVCOM
; Prepare to save program to memory from the editor
.SVPRG  LDX     #PROGRAM
; Will fall through to common components        
; Common components of loading program/data
.SVCOM  STX     CPYDST          
        LDX     #$E080
        STX     CPYSRC
        JSR     COPYSTR
        RTS

.RSTCRS JSR     HOME           ; Initialise where the editor cursor starts
        LDAB    #5
        JSR     MULTCR
        RTS

.SWPLBL LDX     #LBLPRG        ; Load X with the start of the program label
        TST     PRGDAT         ; Swap program/data label over in editor
        BEQ     .SLISPG        ; This is data, not program, so swap the label
        LDX     #LBLDAT        ; Load X with the start of the data label

.SLISPG LDAA    #0
        STAA    CURSX
        LDAB    #3
        STAB    CURSY
        JSR     MSGXY          ; Display the label at (X,Y)
        JSR     .RSTCRS        ; Reset cursor to start of editor window
        RTS


.BOX    JSR     HOME 
        LDAB    #4
        JSR     MULTCR
        LDAA    EDBNDY
        LDAB    #32            
        JSR     MLTCHR
        LDAB    #9
        JSR     MULTCR
        LDAA    EDBNDY
        LDAB    #32
        JSR     MLTCHR        ; Editor box printed

        JSR     .RSTCRS       ; Ensure cursor starts at the beginning of the editor
        RTS

; Editor specific variables

STTSCR   .DA    $E080         ; First character of editor
ENDSCR   .DA    $E17F         ; Last character of editor
EOL1     .DA    $E0A0    ; End of first line
CLINE    .DA    0       ; Line that the cursor is in 
LBLPRG   .AZ     /PROGRAM/
LBLDAT   .AZ     /DATA   /


