#!/Users/alexshroyer/repo/k/k
/
concatenate two vtt files, adjusting timestamps
so the second set starts when first set ends
then format and write new name-join.vtt file

NOTE: if you have two .vtt files each with separate sets of clips to extract,
run `vttmerge.k` on each of them first, then you can combine them into a single
.vtt file with `vttcat.k` (this script). This script ignores stdin and doesn't
make any cuts.
\

(file1;file2):x  /filename is only cli arg

read:{(2_0:x)^'"\r"}  /read and also get rid of \r
tidy:{-1_.=x!(#x)#!3} /discard blank lines
(stamp1;text1):tidy read file1
(stamp2;text2):tidy read file2

sec:{(24 60 60/-3#0,`I$":"\*"."\)'" --> "\x}   /sec["01:03:46.000 --> 01:03:53.000"] ⇒ (3826 3833)
ces:{(":"/(-2#"0",)'$24 60 60\x),".000"}       /ces[3826] ⇒ "01:03:46.000"

s22:(*|,/sec'stamp1)+sec'stamp2                /add last timestamp to stamp2
stamps:stamp1," --> "/'ces''s22                /new timestamps for whole file
join:"\r\n\r\n"/"\r\n"/'+(stamps;text1,text2)  /join nested sections with CRLF
rename:{"."/@["."\x;0;{x,"-combined"}]}
{(rename y) 0:"WEBVTT\r\n\r\n",x,"\r\n\r"}[join;file1]
