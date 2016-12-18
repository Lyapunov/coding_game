#!/usr/bin/ruby
require'prime'
p$<.map{|x|x.to_i}.select{|x|Prime.prime?x}.max
