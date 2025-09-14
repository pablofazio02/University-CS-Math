# The Natural Semantics of WHILE

# Files

## Read only files (do not modify them)

Aexp.hs          - abstract syntax and semantics of Aexp
Bexp.hs          - abstract syntax and semantics of Bexp
State.hs         - implementation of State
While.hs         - abstract syntax for WHILE
WhileLexer.hs    - lexer for WHILE
WhileParser.hs   - parser for WHILE
WhileExamples.hs - simple WHILE programs written in abstract syntax
Examples/*.w     - simple WHILE programs written in concrete syntax

## Editable files (to be completed)

NaturalSemantics.hs - Natural Semantics for WHILE
Exercises02.hs      - Exercises 1 to 5

# Plan

NaturalSemantics.hs:

1. Complete the implementation of the Natural Semantics of WHILE

Exercises02.hs:

1. Complete exercise 1
2. At this point, you have implemented an interpreter for WHILE based on its
   Natural Semantics. Use exercise 1 to test your interpreter. Feel free to
   further experiment with a few more WHILE programs.
3. Complete exercises 2 and 3 to extend the WHILE language with new looping
   statements.
4. Complete exercise 4 to define and implement the Natural Semantics for Aexp.
5. Complete exercise 5 to implement a simple static semantics check for WHILE.
