#!/Users/alexshroyer/repo/k/k
/
given a list of start/end points, find:
1. stamp > start
2. stamp < end
3. AND them together to get a boolean mask
4. mask (stamp;text) to extract a clip to keep
5. subtract the start time from all timestamps
6. format and write to .vtt file
\

arg: :[3=#`argv[];`argv[2];"temp.vtt"]   /use "temp.vtt" if no argument provided

/list of start and end times from the video
cut:("00:00:00 --> 00:21:55"
 "00:21:55 --> 00:38:33"
 "00:41:55 --> 00:51:00"
 "00:51:00 --> 01:03:53")

read:{2_0:x}  /x:"/path/to/filename.vtt"
tidy:{-1_.=x!(#x)#!3}

(stamp;text):tidy read arg

sec:{(24 60 60/`I$":"\*"."\)'" --> "\x}  /parse timestamps to seconds "01:03:46.000 --> 01:03:53.000" becomes (3826 3833)
ces:{(":"/(-2#"0",)'$24 60 60\x),".000"} /inv(sec): "01:03:46.000" ~ ces[3826]

(start;end):+sec'cut
starts:(*&)'start<\:*+sec'stamp
ends:(*&)'end<\:*+sec'stamp
secstamp:*+sec'stamp
s:start<\:secstamp /start mask
e:end>\:secstamp /end mask
mask:&'e&s  /start and end masks overlap
(stamp2;text2):(stamp;text^'"\r")@\:mask
/reset:{({x,"\r\n"}@" --> "/ces@')''{x-*'*'x}@sec''x} /make sections start at 00:00:00.000
reset:{({x,"\r\n"}@" --> "/ces@')''(sec''x)-*+sec'cut} /make sections start at 00:00:00.000
vtts:+'+(reset stamp2;text2)

texts:{("WEBVTT\r\n\r\n","\r\n\r\n"/,/'x),"\r\n\r"}'vtts  /format line endings
{(((-4_arg),"-cut",$y),".vtt")0:x}'[texts;1+!#texts];  /write files using 1.vtt, 2.vtt, 3.vtt, ... etc.
