#!/usr/bin/ruby
nodes=Array.new

n = gets.to_i
n.times do
    x, y = gets.split(" ").map(&:to_i)
    nodes.push([x, y])
end

#nodes.each{|x,y| p [x,y]}

minx = nodes.map{|x,y|x}.min
maxx = nodes.map{|x,y|x}.max

nodes = nodes.sort_by{|x,y| y}
len   = nodes.length
posyf = ( nodes[(len-1)/2][1] + nodes[len/2][1] ) / 2.0
posy  = posyf.round

clen  = (maxx-minx)
nodes.each{|x,y| clen += (y-posy).abs}

#puts ""+minx.to_s+" "+maxx.to_s+" "+posy.to_s

puts clen
