# Suggestion from @BenZotto - use editor as the means to enter BF programs


- Use CTRL-E to enter the editor from the executive
- Use CTRL-R to RE-EDIT the existing code.

    - BUFADR  is the start of the source code   Starts at 0x200
    - BUFEND  is the end of the source code     Maximum is 0xFFF

#### Editor Controls ####
    
    - CTRL-L    Set cursor to the home position
    - CTRL-X    Clears the screen from the cursor position to the bottom of the screen
    - CTRL-Q    Moves the cursor up one line
    - CTRL-R    Moves the cursor right one character
    - CTRL-S    Moves the cursor down one line
    - CTRL-T    Moves the cursor one character to the left
    - CTRL-DEL  Moves the cursor to the left of the screen
    - CTRL-D    Deletes the top line of the CRT
    - CTRL-I    Insert a new line at the top of the CRT
    - CTRL-E    Enter editor
    - CR        Moves the cursor to the next line at the left of the screen
    - ESC       Exit the editor
    

# Hello World! program

>++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+.