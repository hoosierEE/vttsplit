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
vttfile:*x  /filename is only cli arg
cut:0:0                  /timestamps come from stdin


cut:(" --> "/"-"\)'cut   /format timestamps from "t1-t2" to "t1 --> t2"
read:{+0N 2#{x@&-1<x}'1_((0:x)^'"\r")^,""}
(stamp;text):read vttfile

sec:{(24 60 60/-3#0,`I$":"\*"."\)'" --> "\x}  /sec["01:03:46.000 --> 01:03:53.000"] ⇒ (3826 3833)
ces:{(":"/(-2#"0",)'$24 60 60\x),".000"}      /ces[3826] ⇒ "01:03:46.000"

(start;end):+sec'cut
(s0;s1):+sec'stamp
overlap:(start<\:s0)&~end<\:s0                   /drop overlapping segemnts
shstamp:sec''stamp@&'overlap                     /stamps in shape of clips
shstamp:(0N 2#)'(start,'(1_-1_,/)'shstamp),'end  /apply start/end cut logic
offset:+\0,1_*+0N 2#-':,/((*:;*|:)@\:,/)'shstamp /accumulate gaps between start/end of each clip

mask:{x@&~=':x}@,/&'overlap

ns:,/(shstamp-offset)-+\0,1_*+0N 2#-':,/((*:;*|:)@\:,/)'shstamp-offset
ns:,/shstamp-offset  /new timestamps
nt:text mask                           /new text
vtts:+(" --> "/'ces''ns;nt)

join:"\r\n\r\n"/"\r\n"/'vtts           /join nested sections with CRLF

rename:{"."/@["."\x;0;{x,"-cut"}]}
{(rename y) 0:"WEBVTT\r\n\r\n",x,"\r\n\r"}[join;vttfile]

/
cast of characters: katie is behind - cut a-b should keep caption that starts at b
relapse prevention: katie is ahead
the bubble: katie is ahead
obsessional sequence: no caption at 9:54 should say "Here's our learning checkpoint", but no caption until 10:12 (and here are wrong words) and Katie is ahead at the very end
\
