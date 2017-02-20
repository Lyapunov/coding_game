#!/usr/bin/perl
$_=<>;$i=(length)%2;print(($i=1-$i)?uc$_:lc$_)for/./g
