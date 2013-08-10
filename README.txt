PASCAL-P4 FOR FREE PASCAL AND DELPHI
====================================

The Pascal-P4 compiler ported to Free Pascal and Delphi.

By Christophe Staiesse <chastai@skynet.be>, 4 August 2013

INTRODUCTION

Pascal-P4 consists of a Pascal compiler written in itself and generating
instructions for a virtual machine, and of an interpreter. It has been written
by students of Niklaus Wirth -- the designer of the Pascal language -- at ETH
Zurich in 1976.

The source code of Pascal-P4 is commented in the book "Pascal Implementation"
by Steven Pemberton and Martin Daniels. The book is available online at
http://homepages.cwi.nl/~steven/pascal/

You can get more information on Pascal-P and on the history of the Pascal
language on the website of Scott Moore: http://standardpascal.org.

PURPOSE

Pascal-P4 can be compiled by an ISO Pascal compiler with little or no
modification but the interpreter has some dependencies to the CDC 6000
architecture and have bugs that prevent it to execute correctly many programs.

The purpose of this project was to fix the bugs, remove the architecture
dependencies and to make Pascal-P4 compilable by Free Pascal and Delphi while
keeping the changes to a minimum and preserving the line numbering as much as
possible.

WEBSITE

The project is hosted at BerliOS: http://developer.berlios.de/projects/pp4fpc/

You will have access to the latest release, a bug tracking tool, RSS feeds
and forums.

Note that the website uses a self-signed SSL certificate. The fingerprint is
shown at the bottom of the login page.

GIT

git has been used to track the changes. The URL of the git repository is
git://git.berlios.de/pp4fpc . You can also browse the repository on the
project Website.

The commit history is also available in the files pcom.diff
(changes made to pcom.pas, the compiler) and pint.diff (changes made to
pint.pas, the interpreter).

HELP

The documentation is somewhat succinct but I will be happy to answer questions
on the forum.

SUMMARY OF THE CHANGES MADE TO THE COMPILER

The file pcom.diff contains a copy of the commit history.

The two main problems preventing Free Pascal or Delphi to compile pcom.pas
were the use of tag-field parameters in calls to new (resolved in commit
c00b96a) and an access to a file buffer variable through the caret syntax
input^) (resolved in commit f076116).

The only configuration variable changed is ordmaxchar (commit a71b6e0). It
defines the maximum ordinal value of a char.

A preprocessor, ppp.pas, has been added to allow the compiler to compile
itself. The preprocessor recognizes only one directive: $IFNDEF PP. This
directive is used to hide code from the compiler, by example the file buffer
variable declarations.

Commits:

 - Rename .p file extensions to .pas (commit f7a0baa)
 - TAB expansion (commit 4925972)
 - Rename identifiers which are kw in FPC or Delphi (commit a860a0f)
 - Remove the only dependence to file buffer variable (commit f076116)
 - Show tag field parameters of new to PP only (commit c00b96a)
 - Comment out procedure printtable (commit 35de197)
 - Solve problem with proc expression forward decl (commit 962943c)
 - Set ordmaxchar to 255 (commit a71b6e0)
 - Assign a filename to prr (commit c345ec5)
 - Hide prr declaration and file opening from pcom (commit f7db76f)
 - Close prr after compilation (commit e475c03)
 - Hide PP compilation directives to other compilers (commit 318dd79)
 - Solve an EOLN problem in Delphi (commit f253cc0)
 - Set the debug flag to on in pcom (commit f832489)
 - Hide the dummy Mark and Release procs to PP (commit 8bd2e84)
 - Fix number alignment problems in code generator (commit 2cad116)

SUMMARY OF THE CHANGES MADE TO THE INTERPRETER

The file pint.diff contains a copy of the commit history.

The main problems in pint.pas were:

 - the use of the caret syntax to access file buffers (commit e5f5e09)
 - Read was expected to have an ISO behaviour (commit 8db01ee) 
 - architecture dependent code in the implementation of:
    - ORD and CHR (solved in commit d4f9aad)
    - INC (solved in commit 31c660c)
    - DEC (solved in commit 00ad393)
    - CHK (solved in commit bb2f7a7)
    - EOF (solved in commit 0fbaed5)
    - WRC (solved in commit 2e1c33c)
    - RDC (solved in commit 799351a)

Most of the architecture dependencies have been resolved by Scott Moore in his
version of Pascal-P4 (see <http://standardpascal.org/p4.html>). Unfortunately
it is still buggy and by example, it is not possible to compile the compiler
with the interpreted version of itself.

Two new routines have been defined in pinthelper.inc:

 - function GetBufCh(Text): Char
     Returns the next char to be read from the text file. Replaces file buffer
     access through the caret syntax (e.g. input^).

 - procedure ReadInt(Text, var Integer)
     ISO Pascal implementation of Read.

Commits:

 - Rename .p file extensions to .pas (commit f7a0baa)
 - TAB expansion (commit 4925972)
 - Rename string to strng (commit 067de1e)
 - Bind prr and prd file variables to filenames (commit 9f26867)
 - Close prr at the end (commit 8de4633)
 - Solve arch dependency in CHKI/B/C impl. (commit bb2f7a7)
 - Solve an arch dependence problem in EOF impl. (commit 0fbaed5)
 - Replace the pack() call by a for loop (commit d13b416)
 - Replace a interproc goto end of prog by halt (commit 333fbdd)
 - Adjust string lit in calls to errori and errorl (commit 3a4e7b4)
 - Replace Get and Put standard calls (commit 5594a5b)
 - Replace file buffer accesses by calls to GetBufCh (commit e5f5e09)
 - Rename getbuf.inc to pinthelper.inc (commit 2f644be)
 - Replace Read(Integer) by ISO-like equivalent (commit 8db01ee)
 - Fix a bug in WRC impl. (commit 2e1c33c)
 - Fix a bug in RLN impl. (commit d7d6875)
 - Fix a bug in readc (commit 799351a)
 - Fix arch dependency with ORD and CHR instr. (commit d4f9aad)
 - Fix arch dependency in INC implementation (commit 31c660c)
 - Fix arch dependency in DEC implementation (commit 00ad393)

USING PASCAL-P

pcom.pas and pint.pas are now compilable with Free Pascal and Delphi.

pcom reads the Pascal program from the standard input and writes the object
code in a file named 'prr'. The error numbers and the listing are displayed on
the standard output. The 'errormsg.txt' file contains the list of the error
messages.

pint.pas interprets the program from the file 'prd'. The standard input and
output and the file 'prr' are binded respectively to the input, output and prr
file variables of the interpreted program. The file 'prd' is still binded to
prd when the program starts. As lazy I/O is not implemented, the interpreter
has to read the first char of the standard input before the program starts.
This means that the user will have to press enter to start the program if the
input stream is not used by the program.

TRYING PASCAL-P ON THE COMMAND LINE

Under Windows
-------------

FPC.EXE is used to compile with Free Pascal and DCC32.EXE with Delphi.

1) Compile the compiler and the interpreter:
    
    C:\pp4fpc\> fpc pcom.pas (or dcc32 pcom.pas with Delphi)
    C:\pp4fpc\> fpc pint.pas

2) Compile the preprocessor with Pascal-P

    C:\pp4fpc\> pcom < ppp.pas
    C:\pp4fpc\> copy prr ppp.pc

3) Preprocess pcom.pas

    C:\pp4fpc\> copy ppp.pc prd
    C:\pp4fpc\> pint < pcom.pas > pcom_pp.pas

4) Compile the compiler with the version compiled by FPC of itself

    C:\pp4fpc\> pcom < pcom_pp.pas
    C:\pp4fpc\> copy prr pcom.pc

5) Compile the compiler with the interpreted version of itself

    C:\pp4fpc\> copy pcom.pc prd
    C:\pp4fpc\> pint < pcom_pp.pas
    C:\pp4fpc\> copy prr pcom_int.pc

6) Compare the outputs of the two version of the compiler with a homemade tool

    C:\pp4fpc\> fpc diff.pas
    C:\pp4fpc\> diff pcom.pc pcom_int.pc

No news from diff is good news.

If compiled with Delphi, pcom and pint will not work correctly with files
formated with Unix line breaks. You can compile and use unix2dos.pas to
convert line breaks if necessary:
C:\pp4fpc\> dcc32 unix2dos.pas
C:\pp4fpc\> unix2dos < pcom.pas > pcom_win.pas

Under Linux (and probably Mac OS X, xBSD, ...)
----------------------------------------------

Simply do make or:

1) Compile the compiler and the interpreter:

    $ fpc pcom.pas
    $ fpc pint.pas

2) Compile the preprocessor with Pascal-P

    $ ./pcom < ppp.pas
    $ cp prr ppp.pc

3) Preprocess pcom.pas

    $ cp ppp.pc prd
    $ ./pint < pcom.pas > pcom_pp.pas

4) Compile the compiler with itself

    $ ./pcom < pcom_pp.pas
    $ cp prr pcom.pc

5) Compile the compiler with the interpreted version of itself

    $ cp pcom.pc prd
    $ ./pint < pcom_pp.pas
    $ cp prr pcom_int.pc

6) Compare the outputs of the two version of the compiler

    $ diff -w pcom.pc pcom_int.pc

No news from diff is good news.

TRYING PASCAL-P WITH AN IDE

If you are using an IDE like Lazarus or Delphi, you would probably want to
bind the standard input or output to some files unless your IDE lets you
redirect them what I think Lazarus and Delphi doesn't allow.

By example to compile sieve.pas:
  
In pcom.pas, bind sieve.pas to the standard input:

    Assign(Input,'sieve.pas');
    Reset(Input);

Bind 'sieve.pc' instead of 'prr' to prr at the end of pcom.pas:
  Replace Assign(prr,'prr') by Assign(prr,'sieve.pas');
  
Build and run pcom. 
    
In pint, replace Assign(prd,'prd') by Assign(prd,'sieve.pc');

Build and run pint and you should see the list of the prime numbers below 100.

It should be easy to modify pcom and pint to accept filenames on the command
line instead of hardcoding them in the source code.

SOME LIMITATIONS OF PASCAL-P

 - uppercases are not allowed excepted in comments.
 - comments are delimited only by (* and *).
 - literal strings are limited to 16 chars.
 - cannot declare file variables. prd is an auxiliary input text file and prr
   an auxiliary output text file and are opened at the start of the program
   by the interpreter.

FUTURE OF THE PROJECT

I would like:
 - a Yacc grammar to document the grammar recognized by pcom (I am working on
   this)
 - a documentation of the virtual machine
 - implementations of the interpreter in different languages.
 - more example programs

SIMILAR PROJECTS

Pascal-P5
  Scott Moore have reworked Pascal-P4 to make it an actual ISO Pascal compiler
  See http://www.standardpascal.org/p5.html

LICENSE

pcom.pas is credited to Urs Ammann, Kesav Nori and Christian Jacobi.

pint.pas is credited to Kathleen Jensen, Niklaus Wirth and Christian Jacobi.

As far as I know, pcom.pas and pint.pas have been released without restriction
of use.

diff.pas, ppp.pas, sieve.pas and unix2dos.pas have been written by Christophe
Staiesse and are licensed under this MIT license:

    Copyright (c) 2013 by Christophe Staiesse

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
