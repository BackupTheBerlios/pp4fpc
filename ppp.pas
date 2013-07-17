(*$c+,d+,t-,l-*)
program ppp(input);
(* an embryo of a preprocessor for Pascal-P.

   by Christophe Staiesse <chastai@skynet.be>

   Made to ease the compilation of pcom by itself.
   Need to be compiled by Pascal-P itself or an ISO compiler.

   Usage:
     input: the source code to preprocess.
     output: the resulting source code.

   Implemented as a state machine resolving this regular expression:
     /\(\*\$IFNDEF\s+PP\s*\*\)/;
   i.e. a '(*' followed by '$IFNDEF' in uppercase followed by one or 
   more blanks followed by 'PP' followed by zero or more blanks followed
   by a comment ending. When this pattern is matched, the comment ending
   is left out (in fact the closing parenthesis is replaced by a space).
   This has for effect to comment out the block of code between this
   directive and the next comment. This means that you cannot use (*-style
   comments within the block; Use {-style comments instead.
*)
var 
    pattern: packed array[1..15] of char;
    state: integer;

(* Advance the input of one character *) 
procedure advance;
begin
    if not eoln then
        get(input)
    else
        readln;
end;

(* Write out the current input character *)
procedure outputch;
begin
    if not eoln then
        write(input^) 
    else 
        writeln;
end;

begin
    state := 0;
    pattern := '(*$IFNDEF  PP *';
    
    (* State machine: all chars are copied from the input to the output with one 
       exception: when the pattern is recognized, the closing parenthesis is replaced
       by a space *)
    while not eof do
    begin
        case state of
            0: (* Copy all chars until the first char of the pattern is encountered *)
              if input^ <> '(' then
              begin
                  outputch;
                  advance;
              end else
                  state := state+1;

            1,2,3,4,5,6,7,8,9, (* '(*$IFNDEF' *)
            (* States 10,11 = one or more blanks*)
            12,13, (* 'PP' *)
            (* State 14 = zero or more blanks *)
            15: (* '*' *) 
              if input^ = pattern[state] then
              begin
                  outputch;
                  advance;
                  state := state+1
              end else
                  state := 0;

            10: (* a blank *)
              if ord(input^) <= 32 then (* ASCII assumed *)
              begin
                  outputch;
                  advance;
                  state := state+1;
              end else
                  state := 0;

            11,14: (* zero or more blanks *)
              if ord(input^) <= 32 then
              begin
                  outputch;
                  advance;
              end else
                  state := state+1;

            16: (* if the pattern has been recognized, replace ')' by ' '
                   and advance. In any case reinit the state machine *)
              begin
                  if input^ = ')' then
                  begin
                      write(' ');
                      advance;
                  end;
                  state := 0;
              end;
        end;
    end;
end.
