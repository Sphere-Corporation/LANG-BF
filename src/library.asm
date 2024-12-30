;
; Library functions 
;
;       V1.0    Released with GAME-TT                   Initial Release
;       V2.0    No Release                              Added STR,RSTR, COPTSTR
;                                                       Moved CURSX, CURSY into GTCHRAT function
;       V3.0    Released with LANG-BF                   Changed to use macro capability of sbasm3
;                                                       To use any macro, include in main program the macro name (detailled below)
;                                                       Included MSGXY

; 
;       To use:
;       -------
;
;       .IN     library                 ; Include this library file
;       
;       >M_COPYSTR                      ; Include any functionality
;              
;
;===============================================================================================
; CLS: Clear the screen (make sure cursor starts of top left first)
;
; Entry:
;       N/A
;
; Exit:
;       N/A
;  
; External definitions:
;       N/A
;
; Dependencies:
;
;       HOME    (System)
;       CLEAR   (System)
;
; Notes:
;       N/A
; 
M_CLS   .MA
CLS     JSR     HOME           ; Move cursor to top left
        JSR     CLEAR          ; Clear the screen
        RTS
        .EM
;===============================================================================================

;===============================================================================================
; COPYSTR:  Copy 256 bytes from the a source to destination address
;
; Entry:
;       CPYSRC       contains the source address to copy from
;       CPYDST       contains the destination address to copy to
;
; Exit:
;       N/A
;  
; External definitions:
;
;       CPYSRC:      2 bytes
;       CPYDST:      2 bytes
;
; Dependencies:
;       RSTR
;       STR
;
; Notes:
;           Credits to Ben Zotto for the original inspiration
;           Small styling modifications to fit in with overall style of source code
;           Adapted to use external parameters
;
     
M_COPYSTR .MA

CPYSRC .BS    2    ; Define 2 byte SOURCE address
CPYDST .BS    2    ; Define 2 byte DESTINATION address

COPYSTR 
 
        JSR     STR
        CLRB
.CPYLWP
        LDX     CPYSRC
        LDAA    0, X
        INCB
        CMPB    #255
        BEQ     .CPYEND
        INX
        STX     CPYSRC
        LDX     CPYDST
        STAA    0, X
        INX
        STX     CPYDST
        BRA     .CPYLWP
.CPYEND JSR     RSTR
        RTS
        .EM
;===============================================================================================

;===============================================================================================
; CRLF: Emits a carriage return
;
; Entry:
;   
;       N/A
;
; Exit:
;       N/A
;  
; External definitions:
;      
;       N/A
;
; Dependencies:
;
;       PUTCHR  (System)
;       RSTR
;       STR
;
; Notes:
;
;       N/A

M_CRLF  .MA
CRLF    JSR     STR            ; Store A/B/X    
        LDAA    #$0D
        JSR     PUTCHR         ; Output a CR at the current cursor position
        JSR     RSTR           ; Restore X/B/X
        RTS
        .EM
;===============================================================================================

;===============================================================================================
; CURXY: Move the cursor to co-ordinates (X,Y) on the screen (0,0) is top left
;
; Entry:
;       AccA            Contains the X coordinate
;       AccB            Contains the Y coordinate
;
; Exit:
;       X               Correct cursor position offset
;  
; External definitions:
;       CSRPTR          (System - Cursor Pointer)
;       XCRD, YCRD      1 byte each
; Dependencies:
;
;       HOME    (System)  
;
; Notes:
;
;       Logic:
;       Multiply the Y co-ordinate by 32 (line length) - repeatedly INX 32 times per line
;       Add the X co-ordinate to give offset
;       Memory location to store character = CSRPTR (CURSOR POINTER)
    
M_CURXY .MA
XCRD   .DA     $FF             ; Storage for X coordinate
YCRD   .DA     $FF             ; Storage for Y coordinate

CURXY   STAA    XCRD           ; Store AccA/AccB scratch locations
        DECB                   ; BUT decrement Y co-ordinate to make it zero-based first
        STAB    YCRD
        JSR     HOME           ; Send CRSPTR to "Home" to register as (0,0)                        

; Start incrementing the X index register
        LDX     CSRPTR         ; Load current Cursor position (0,0) into X register

.NXTLN  CLRA
        LDAB    #32            ; Add 32 (1 line) to the X register
         
.YAGAIN BEQ     .OUTY
        INX
        DECB
        BRA     .YAGAIN
.OUTY        

; Prepare for the next line by decrementing the Y coordinate until zero
        LDAA    YCRD
        DECA
        BEQ     TOX
        STAA    YCRD
        BRA     .NXTLN

; Add the X coordinate by decrementing the supplied X coordinate until zero
TOX     LDAB    XCRD
.XAGAIN BEQ     XCURXY
        INX
        DECB
        BRA     .XAGAIN
XCURXY  RTS
        .EM
;===============================================================================================

;===============================================================================================
; GETCHRB : Get a character from the keyboard without flashing the cursor
;     
; Entry:
;   
;       N/A
;
; Exit:
;       AccA        Contains the typed character
;  
; External definitions:
;      
;       KBDPIA: Address of PIA for KBD/2 (Only supports KBD/2)
;
; Dependencies:
;
;       N/A
;
; Notes:
;
;       N/A 
M_GETCHRB .MA
GETCHRB LDAA    #$40           ; Load a mask for CA2 flag.
        BITA    KBDPIA+1       ; See if a character has been typed in.
        BEQ     GETCHRB        ; Try again if a character hasn't been entered.
        LDAA    KBDPIA         ; Load AccA with the typed character
        RTS              
        .EM
;===============================================================================================

;===============================================================================================
; GTCHRAT: Get the character at the cursor position stored as below
; 
; Entry:
;       CURSX       Contains the X coordinate
;       CURSY       Contains the Y coordinate
; 
; Exit:
;       CHARAT      Contains the character at the supplied coordinates (on exit)
;
; External definitions:
;
;       CURSX:      1 byte
;       CURSY:      1 byte
;
; Dependencies:
;
;       CURXY   
;       RSTR
;       STR
;
; Notes:
;
;       N/A 

M_GTCHRAT .MA
CHARAT  .DA     1              ; Storage for character at (X,Y)
CURSX   .DA     1              ; X co-ordinate
CURSY   .DA     1              ; Y co-ordinate


GTCHRAT             
        JSR     STR            ; Store A/B/X
        LDAA    CURSX          ; Get the X co-ordinate of the cursor position
        LDAB    CURSY          ; Get the Y co-ordinate of the cursor position
        JSR     CURXY          ; Ensure pointing at the current cursor position
        LDAA    0,X            ; Get character from screen
        STAA    CHARAT         ; Store character at cursor position
        JSR     RSTR           ; Restore A/B/X
        RTS
        .EM
;===============================================================================================

;===============================================================================================
; MLTCHR: Prints a given char (n) times
;
; A Accumulator contains the character for multiple printings goes here.
; B Accumulator contains the multiple (n)
; Entry:
;   
;       AccA            Contains the character for multiple printing
;       AccB            Contains the multiple (n)
;
; Exit:
;       N/A
;  
; External definitions:
;      
;       N/A
;
; Dependencies:
;
;       PUTCHR  (System)
;
; Notes:
;
;       AccB will lose its value

M_MLTCHR .MA
MLTCHR
.MLOOP  BEQ      .FINAL
        JSR      PUTCHR
        DECB
        BRA      .MLOOP
.FINAL  RTS
        .EM
;===============================================================================================

;===============================================================================================
; MSGXY: Print a zero-terminated message at a specific location
;
M_MSGXY .MA
MSGXY   
.MXYLP  LDAA    0,X            ; Get the next character of the message
        STAA    XYCHA          ; Store it in XYCHA ready for output
        BEQ     .MXYDN         ; If AccA is zero, jump to the end
        LDAA    CURSX          ; CURSX is the X co-ordinate 
        JSR     PRTXY          ; Otherwise, output the character
        INX                    ; Increment X (look at the next character)
        INC     CURSX          ; Increment the X position
        BRA     .MXYLP         ; Go around the loop again
.MXYDN
        RTS
        .EM
;===============================================================================================

;===============================================================================================
; MULTCR: Emits multiple blank lines
;
; Entry:
;   
;       AccB            Contains the number of blank lines to print
;
; Exit:
;       N/A
;  
; External definitions:
;      
;       N/A
;
; Dependencies:
;
;       CRLF  
;       RSTR
;       STR
;
; Notes:
;
;       N/A     

M_MULTCR .MA
MULTCR  JSR     STR            ; Store A/B/X
.AGAIN  DECB
        BEQ     .OUT
        STAB    .MCRB
        JSR     CRLF           ; Output a CR at the current cursor position
        LDAB    .MCRB
        BRA     .AGAIN
.OUT    JSR     RSTR           ; Restore X/B/X
        RTS

.MCRB  .DA     1               ; Scratch store for AccB
        .EM
;===============================================================================================
;===============================================================================================
; PRTXY: Prints a given char at co-ordinates (X,Y) on the screen (0,0) is top left
; 
; Entry:
;       AccA            Contains the X coordinate
;       AccB            Contains the Y coordinate
;       XYCHA           Contains the character to print
;
; Exit:
;       N/A
;  
; External definitions:
;      
;       XYCHA           1 byte
;
; Dependencies:
;
;       CURXY  
;       RSTR
;       STR
;
; Notes:
;
;       N/A     
M_PRTXY .MA
PRTXY   JSR     STR
        JSR     CURXY          ; Move the cursor to the correct loctation
        LDAA    XYCHA          ; Load character into AccA
        STAA    0,X            ; Send to screen
        JSR     RSTR
        RTS

XYCHA   .DA     #0             ; Storage for character to print
        .EM
;===============================================================================================

;===============================================================================================
; PUTMSG: Prints a zero-terminated message  
;
; Entry:
;   
;       X           Contains the start address of the message
;
; Exit:
;       N/A
;  
; External definitions:
;      
;       N/A
;
; Dependencies:
;
;       PUTCHR  (System)
;       RSTR    (Optional - comment out if not required)
;       STR     (Optional - comment out if not required)
;
; Notes:
;
;       Comment out the STR/RSTR if not required
;
M_PUTMSG .MA
PUTMSG  
;        JSR     STR            ; Store A/B/X
        LDAA    0,X            ; Start at the beginning of the message
        BEQ     .PMEXT         ; Quit if the message is complete
        STX     .MSGIDX        ; Store the current position in the message
        JSR     PUTCHR         ; Print the current character (Uses X)
        LDX     .MSGIDX        ; Restore the current position in the message
        INX                    ; Increment the message position
        BRA     PUTMSG         ; Go to the next character
.PMEXT  
;        JSR     RSTR           ; Restore A/B/X
        RTS

; Space to store the index register
.MSGIDX .DA     1             ; Reserved space for local variable
        .EM
;===============================================================================================
        
;===============================================================================================
; RSTR: Restore A/B/X prior to returning from a subroutine
;
M_RSTR  .MA
RSTR    LDAA    SCRTCHA
        LDAB    SCRTCHB
        LDX     SCRTCHX
        RTS
        .EM
;===============================================================================================

;===============================================================================================
; STR: Store A/B/X prior to a subroutine
;
M_STR   .MA
STR     STAA    SCRTCHA
        STAB    SCRTCHB
        STX     SCRTCHX
        RTS
        .EM
;===============================================================================================

