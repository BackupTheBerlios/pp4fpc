#!/usr/bin/perl

while (<>) {
    s/\(\*\$IFNDEF\s+PP\s*\*\).*?\(\*\$ENDIF\s*\*\)//gi;
    print
}
