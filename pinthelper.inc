uses SysUtils;

{Helper routine for pint.pas                                          }
{to replace accesses to file buffer variables through the caret syntax}
{as this syntax is not supported by Delphi or Free Pascal             }

function GetBufCh(var f: Text): Char;
{Returns the current char of the specified file buffer}
{Equivalent to GetBufCh := f^                         }
{Note: no error if the file is not opened in reading}
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

