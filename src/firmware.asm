; Firmware entry points (PDS-V3N)

HOME    .EQU     $FC37         ; Cursor to top left
CLEAR   .EQU     $FC3D         ; Clear screen contents
;GETCHR  .EQU     $FC4A         ; Gets a single character into A (with cursor blinking)
PUTCHR  .EQU     $FCBC         ; Print character at cursor
INPCHR  .EQU     $FE71         ; Reads and displays a character

KBDPIA  .EQU     $F040         ; Address of PIA for KBD/2 (Only supports KBD/2)

; PDS Workspace

CSRPTR  .EQU     $1C           ; Current cursor location
