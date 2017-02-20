#!/usr/bin/perl
sub z{<>=~/\d/g};($a,$b,$c,$d,$r)=(z(),z(),z());$n=$a x $b.$c x $d;print($n),$n=~y/0-9/1-90/ for 1..$r
