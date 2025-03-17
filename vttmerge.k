#!/Users/alexshroyer/repo/k/k
/
given a name.vtt file and a list of start/end points, find:
1. stamp > start
2. stamp < end
3. AND them together to get a boolean mask
4. mask (stamp;text) to extract a clip to keep
5. adjust clip so it begins where previous clip ends
6. format and write new name-merge.vtt file
\
/test data
/ vttfile:"/Users/alexshroyer/Downloads/timestamps/Relapse Prevention/GMT20250310-165845_Recording.cc.vtt"
/ cut:("00:00 --> 00:59";"01:45 --> 05:19";"5:21 --> 07:23";"07:31 --> 07:51")

/actual data
(vttfile;rest):(*x;1_x)  /filename is only cli arg
cut:0:0                  /timestamps come from stdin
cut:(" --> "/"-"\)'cut   /format timestamps from "t1-t2" to "t1 --> t2"

read:{2_0:x}  /x:"/path/to/filename.vtt"
tidy:{-1_.=x!(#x)#!3}
(stamp;text):tidy read vttfile

sec:{(24 60 60/-3#0,`I$":"\*"."\)'" --> "\x}  /sec["01:03:46.000 --> 01:03:53.000"] ⇒ (3826 3833)
ces:{(":"/(-2#"0",)'$24 60 60\x),".000"}      /ces[3826] ⇒ "01:03:46.000"

(start;end):+sec'cut
secstamp:*+sec'stamp
starts:(*&)'start<\:secstamp
ends:(*&)'end<\:secstamp
s:start<\:secstamp            /start mask
e:end>\:secstamp              /end mask
mask:&'e&s                    /start and end masks overlap

(stamp2;text2):(stamp;text^'"\r")@\:mask                   /uniform line endings

se2:sec''stamp2
ns:" --> "/'ces'',/se2-*'{x*0,1_(#x)#1}@-1_(0,+\#'se2)_*+0N 2#-':,//se2
vtts:+(ns;,/text2)                                         /merge times and combine with text
join:"\r\n\r\n"/"\r\n"/'vtts                       /join nested sections with CRLF

rename:{"."/@["."\x;0;{x,"-cut"}]}
{(rename y) 0:"WEBVTT\r\n\r\n",x,"\r\n\r"}[join;vttfile]
