#!/usr/bin/perl
@z=2..<>;for$i(@z){@z=grep$i>=$_||$_%$i,@z}print~~@z
#23456789 123456789 123456789 123456789 123456789 123456789 

;print "\n",join(",",@z)