#!/usr/bin/ruby
require'prime'
@n=gets.to_i
m=Array.new
@n.times do 
k=gets.to_i
if Prime.prime?(k) 
m.push(k)end end
puts m.max
