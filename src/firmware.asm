; Firmware entry points (PDS-V3N)

HOME    .EQU     $FC37         ; Cursor to top left
CLEAR   .EQU     $FC3D         ; Clear screen contents
GETCHR  .EQU     $FC4A         ; Gets a single character into A (with cursor blinking)
LFTJST  .EQU     $FCFD         ; Send the cursor to the far left of the current line
PUTCHR  .EQU     $FCBC         ; Print character at cursor
INPCHR  .EQU     $FE71         ; Reads and displays a character
ADD32   .EQU     $FCD5         ; Moves cursor down a line on the screen
KBDPIA  .EQU     $F040         ; Address of PIA for KBD/2 (Only supports KBD/2)
SUB32   .EQU     $FCCB         ; Moves cursor up a line on the screen
; PDS Workspace

CSRPTR  .EQU     $1C           ; Current cursor location
