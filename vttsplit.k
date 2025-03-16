#!/Users/alexshroyer/repo/k/k
/
given a name.vtt file and a list of start/end points, find:
1. stamp > start
2. stamp < end
3. AND them together to get a boolean mask
4. mask (stamp;text) to extract a clip to keep
5. subtract the start time from all timestamps
6. format and write multiple new name<i>.vtt files where <i> corresponds to each clip
\
vttfile:*x /filename is only cli arg
cut:0:0    /timestamps come from stdin
cut:(" --> "/"-"\)'cut /format timestamps from "t1-t2" to "t1 --> t2"

read:{2_0:x}  /x:"/path/to/filename.vtt"
tidy:{-1_.=x!(#x)#!3}
(stamp;text):tidy read vttfile

sec:{(24 60 60/3#0,`I$":"\*"."\)'" --> "\x}  /parse timestamps to seconds "01:03:46.000 --> 01:03:53.000" becomes (3826 3833)
ces:{(":"/(-2#"0",)'$24 60 60\x),".000"} /inv(sec): "01:03:46.000" ~ ces[3826]

(start;end):+sec'cut
secstamp:*+sec'stamp
starts:(*&)'start<\:secstamp
ends:(*&)'end<\:secstamp
s:start<\:secstamp /start mask
e:end>\:secstamp   /end mask
mask:&'e&s         /start and end masks overlap
(stamp2;text2):(stamp;text^'"\r")@\:mask
reset:{({x,"\r\n"}@" --> "/ces@')''(sec''x)-*+sec'cut} /make sections start at 00:00:00.000
vtts:+'+(reset stamp2;text2)
texts:{("WEBVTT\r\n\r\n","\r\n\r\n"/,/'x),"\r\n\r"}'vtts  /format line endings
{(((-4_vttfile),"-cut",$y),".vtt")0:x}'[texts;1+!#texts];  /write name1.vtt, name2.vtt... etc.
