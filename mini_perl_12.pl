#!/usr/bin/perl
<>;<>;while(<>){$i=$r=0;$z[$i++]+=$_,$r+=$_,$k=($k,$_)[$k<$_]for/\d+/g;$s=$r if$r>$s}print+(sort{$b<=>$a}@z)[0]," $s $k"
