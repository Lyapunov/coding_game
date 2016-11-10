#!/usr/bin/ruby
require'prime'

@n = gets.to_i
p Prime.take( @n )
p Prime.take_while {|p| p < @n }
