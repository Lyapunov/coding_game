#!/bin/bash
a=(HO HA HE HI BO BA BE BI KO KA KE KI DO DA DE DI)
read x
for z in `bc<<<"obase=16;$x" | fold -1`;do
    o+=${a[`bc<<<"ibase=16;$z"`]}
done
echo $o
