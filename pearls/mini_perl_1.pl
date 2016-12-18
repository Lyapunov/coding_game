#!/usr/bin/perl
$i=keys%{{map{uc($_)=>1}split('',<>)}};print($i-1)
