# Notes

## Explanation

These notes are for use during development

### Suggestions and useful information

#### Suggestion from @BenZotto - use editor as the means to enter BF programs

- Use CTRL-E to enter the editor from the executive
- Use CTRL-R to RE-EDIT the existing code.

- BUFADR  is the start of the source code   Starts at 0x200
- BUFEND  is the end of the source code     Maximum is 0xFFF

#### Editor Controls

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

#### Hello World! program

```brainfuck
>++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+.
```

## Talk by BF inventor (Urban Müller)

<https://www.youtube.com/watch?v=gjm9irBs96U&t=8722s>

## Additional ideas

- Maybe use `!` to indicate start of data
- Maybe use `#` to indicate start of input

.... so the program can be in one file along with its input and data.

Possibly support standard input where there is no input given

Loop Cell contents:

42x0
2A
0
0
0
2E

Data pointer address = $03A1
Loop cell address = $F00
extract 50 bytes

USEFUL SOFTWARE FOR MC6800 - MOTOROLA USERS GROUP SOFTWARE
http://test.dankohn.info/~myhome/projects/68HC11/AXIOM_HC11/Source/Users%20Group/




## Editor
Construct a small editor 256/8 lines on each row bordered by some non-BF character
Use cursor movements from GAME-TT to move cursor about

## Verification of program
Allow bracket-checking to occur - count number of open vs closed brackets.
start at zero 
    o_count + 1 for open
    c_count + 1 for close
if o_count == c_count then all ok otherwise error.

