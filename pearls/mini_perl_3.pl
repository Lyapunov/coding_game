#!/usr/bin/perl
# Counting vovels in words, in 54 characters
$_=lc<>;print join" ",map{s/[^aeoui]//g;length}m/\S+/g
