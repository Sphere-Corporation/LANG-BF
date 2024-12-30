# Language characters

|Character| Function              |
|---------|-----------------------|
| **+**   |  Increment the byte at the data pointer by one. |
| **,**   |  Accept one byte of input, storing its value in the byte at the data pointer. |
| **-**   |  Decrement the byte at the data pointer by one. |
| **.**   |  Output the byte at the data pointer. |
| **<**   |  Decrement the data pointer by one (to point to the next cell to the left). |
| **>**   | Increment the data pointer by one (to point to the next cell to the right). |
| **[**   |  If the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command, jump it forward to the command after the matching ] command. |
| **]**   |  If the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it back to the command after the matching [ command. |

[Back to Main Page](../README.md)
