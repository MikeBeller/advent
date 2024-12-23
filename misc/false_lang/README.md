# FALSE machine

This is an implementation of the "FALSE" esoteric programming language,
invented in 1993 by Wouter van Oortmerssen.   https://strlen.com/false-language/

It predates, and was the primary inspiration, for the fairly well known
brainf*ck language.

I find this language actually useful, but most of the implementations are
very old.  I wrote this one to use for Advent of Code.

Summary of the language, taken from its [documentation](https://strlen.com/files/lang/false/false.txt) is reproduced below.

My implementation has a linear memory of number-bearing cells.  Variables
a-z are implemented as memory cells 0-25.  The value stack grows from
26 upwards.  As was possible in the original implementation, you can
peek and poke any memory location in the machine (up to its max memory
which is by default 65535 cells) using : and ; with raw address numbers,
rather than the letters a-z.  This makes arrays a lot easier!  Watch out,
in the future I intend to grow the return stack down from 65535 so maybe
stay out of poking the top 1024 cells or so!.



| Syntax     | Pops       | Pushes     | Example                          |
|------------|------------|------------|----------------------------------|
| {comment}  | -          | -          | { this is a comment }            |
| [code]     | -          | function   | [1+] { (lambda (x) (+ x 1)) }    |
| a .. z     | -          | varadr     | a { use a: or a; }               |
| integer    | -          | value      | 1                                |
| 'char      | -          | value      | 'A { 65 }                        |
| num`       | -          | -          | 0` { emitword(0) }               |
| :          | n,varadr   | -          | 1a: { a:=1 }                     |
| ;          | varadr     | varvalue   | a; { a }                         |
| !          | function   | -          | f;! { f() }                      |
| +          | n1,n2      | n1+n2      | 1 2+ { 1+2 }                     |
| -          | n1,n2      | n1-n2      | 1 2-                             |
| *          | n1,n2      | n1*n2      | 1 2*                             |
| /          | n1,n2      | n1/n2      | 1 2/                             |
| _          | n          | -n         | 1_ { -1 }                        |
| =          | n1,n2      | n1=n2      | 1 2=~ { 1<>2 }                   |
| >          | n1,n2      | n1>n2      | 1 2>                             |
| &          | n1,n2      | n1 and n2  | 1 2& { 1 and 2 }                 |
| |          | n1,n2      | n1 or n2   | 1 2|                             |
| ~          | n          | not n      | 0~ { -1,TRUE }                   |
| $          | n          | n,n        | 1$ { dupl. top stack }           |
| %          | n          | -          | 1% { del. top stack }            |
| \          | n1,n2      | n2,n1      | 1 2\ { swap }                    |
| @          | n,n1,n2    | n1,n2,n    | 1 2 3@ { rot }                   |
| ø (alt-o)  | n          | v          | 1 2 1ø { pick }                  |
| ?          | bool,fun   | -          | a;2=[1f;!]? { if a=2 then f(1) } |
| #          | boolf,fun  | -          | 1[$100<][1+]# { while a<100 do a:=a+1 } |
| .          | n          | -          | 1. { printnum(1) }               |
| "string"   | -          | -          | "hi!" { printstr("hi!") }        |
| ,          | ch         | -          | 10, { putc(10) }                 |
| ^          | -          | ch         | ^ { getc() }                     |
| ß (alt-s)  | -          | -          | ß { flush() }                    |
