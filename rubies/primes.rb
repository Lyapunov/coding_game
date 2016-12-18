#!/usr/bin/ruby
require'prime'
k=gets.to_i
p Prime.take_while{|x|x<k}.size
