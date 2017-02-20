#!/usr/bin/perl
@z=<>=~/\d+/g;++$i,$z[$i+1]=$z[$i]%$_,$z[$i]=int$z[$i]/$_ for 25,10,5;print"@z"
