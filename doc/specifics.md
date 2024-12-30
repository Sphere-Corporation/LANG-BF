# Implementation Specifics

As noted in [this section](https://esolangs.org/wiki/brainfuck#Implementation_issues) of the [esolang wiki page for BrainF***](https://esolangs.org/wiki/brainfuck), there are various implementation specifics which need to be understood, since there is no accepted global standard for implementations.

These implementation specifics are:

## Cell range

Each cell will have a value of 0 < n 255 - note these are unsigned integers.

Cell values will wrap i.e.:
<center>
<pre>
255 + 1 = 0
0 - 1 = 255
</pre>
</center>

## ASCII Characters

Only printable-characters will be output correctly.

The set of characters that the SPHERE-1 recognises is shown [here](doc/ascii.png) (taken directly from Appendix B of the Sphere-1 Operator's Manual). Note that there are many unprintable characters also shown in this list, and that it is 7-bit ASCII i.e. no characters with a value of greater than 127 are available.
It is also worth noting that without a modification, only upper case characters are printable with the base SPHERE-1 implementation.

## Program Size

Due to several limits imposed by the interpreter and the computer itself,

- limited memory
- a maximum of 127 '`[`' and '`]`' pairs can be used (note that this number leaves no scope for any other instructions)

 the program size is limited to ***255*** instructions.

## Tape Storage Size

Due to limited memory on the base Sphere-1 computer, the tape size is limited to ***255*** locations.
Tape storage does **not** have negative values i.e. the tape pointer cannot be positioned beyond what is considered to be the first cell in the tape storage (location 0).

## Error Messages

This implementation of BrainF**k is capable of displaying error messages when specific conditions are reached or breached:

|Error Code |Meaning| Notes |
|-----------|-------|-------|
| E001      |Program length exceeds 255 instructions| This will cause execution to cease when the 255th instruction has been reached and executed|
| E002      |Tape storage length exceeds length > 255 locations| This will cause the program to cease|
| E003      |Tape storage pointer is less than cell zero| This will cause the program to cease|

[Back to Main Page](../README.md)
