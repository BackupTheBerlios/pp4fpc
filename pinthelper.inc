uses SysUtils;

{Helper routines for pint.pas}

function GetBufCh(var f: Text): Char;
{Replace accesses to file buffer variables through the caret syntax}
{as this syntax is not supported by Delphi or Free Pascal.         }
{Returns the current char of the specified file buffer             }
{Equivalent to GetBufCh := f^                                      }
{Note: no error if the file is not opened in reading               }
type
  DeviceFunc = function(var f: TTextRec): Integer;
begin
  {Load the buffer if empty}
  if (TTextRec(f).mode = fmInput)
    and (TTextRec(f).BufPos >= TTextRec(f).BufEnd) then
      DeviceFunc(TTextRec(f).InOutFunc)(TTextRec(f));

  {Returns the current char}
  GetBufCh := TTextRec(f).Buffer[TTextRec(f).BufPos];
end;

procedure ReadInt(var f: Text; var i: Integer);
{Implement ISO Read() function call on integer                            }
{In ISO Pascal, only the characters forming the number are read whereas in}
{Delphi and Free Pascal, the characters are read until the next blank.    }
{Note: doesn't check for integer overflow.                                }
var ch: Char;
begin
	i := 0;

    {Skip leading blanks}
    while GetBufCh(f) <= ' ' do
      Read(f,ch);

    {Read the number}
	while GetBufCh(f) in ['0'..'9'] do
	  begin
        Read(f,ch);
        i := i*10+Ord(ch)-Ord('0');
      end;
end;

