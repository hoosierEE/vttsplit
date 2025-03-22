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

vttfile:*x                                       /filename is only cli arg
cut:0:0                                          /timestamps come from stdin

cut:(" --> "/"-"\)'cut                           /format timestamps from "t1-t2" to "t1 --> t2"
read:{+0N 2#{x@&-1<x}'1_((0:x)^'"\r")^,""}       /read file, parse line types, reshape
(stamp;text):read vttfile

sec:{(24 60 60/-3#0,`I$":"\*"."\)'" --> "\x}     /sec["01:03:46.000 --> 01:03:53.000"] ⇒ (3826 3833)
ces:{(":"/(-2#"0",)'$24 60 60\x),".000"}         /ces[3826] ⇒ "01:03:46.000"

(start;end):+sec'cut                             /integer second format for start and end of cuts
(s0;s1):+sec'stamp                               /as above, but for timestamps
overlap:(start<\:s0)&~end<\:s0                   /where cut start/end overlaps stamp *start*
shstamp:sec''stamp@&'overlap                     /stamps in shape of clips
shstamp:(0N 2#)'(start,'(1_-1_,/)'shstamp),'end  /apply start/end cut logic
offset:+\0,1_*+0N 2#-':,/((*:;*|:)@\:,/)'shstamp /accumulate gaps between start/end of each clip

/NOTE: from here on, we no longer need the shape of each cut so we can flatten everything
ns:,/shstamp-offset                              /new timestamps
nt:text@?,/&'overlap                             /new text
vtts:+(" --> "/'ces''ns;nt)                      /combine
join:"\r\n\r\n"/"\r\n"/'vtts                     /join nested sections with CRLF
rename:{"."/@["."\x;0;{x,"-cut"}]}
{(rename y) 0:"WEBVTT\r\n\r\n",x,"\r\n\r"}[join;vttfile]
