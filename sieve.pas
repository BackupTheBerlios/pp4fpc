(*$c+,d+,l-,t-*)
(*
  Sieve of Eratosthenes. Displays primes less than 'n'.
  
  By Christophe Staiesse.
*)
program eratosthenessieve;
const
        n = 100;
var
        a: array[2..n] of boolean;
        i,j: integer;
begin
        for i := 2 to n do a[i] := true;
        i := 2;
        while sqr(i) <= n do begin
                if a[i] then begin
                        j := sqr(i);
                        while j <= n do begin
                                a[j] := false;
                                j := j+i; 
                        end;
                end;
                i := i +1;
        end;
        for i := 2 to n do
                if a[i] then writeln(i);
end.
