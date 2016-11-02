#!/usr/bin/perl
$_=<>;s!(\S)!$j[$k{$1}++]=1!ge;print~~@j
