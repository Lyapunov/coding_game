#!/usr/bin/perl
<>;@k=<>;$_=(shift@k)." ".pop@k;y/ /+/;s/\+$//;$s+=eval;/\S+$/g,$s+=$_+$& for@k;print$s
