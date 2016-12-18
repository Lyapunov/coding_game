#!/usr/bin/perl
($n,@k)=<>;$_=pop@k;pop@k;--$n;for$a(/\S+/g){substr($k[$_],-1,0)=$n-$a<$_?"#":"."for 0..$n}print@k
