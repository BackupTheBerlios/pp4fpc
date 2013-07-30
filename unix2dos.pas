program unix2dos(input,output);
(* Convert Unix line endings to DOS line endings *)
var
  ch, prevch: char;
begin
  prevch := ' ';
  while not eof do
    begin
      read(ch);
      if (ch = chr(10)) and (prevch <> chr(13)) then
        write(chr(13));
      write(ch);
      prevch := ch;  
    end
end.
