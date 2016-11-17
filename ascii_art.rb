#!/usr/bin/ruby
l = gets.to_i
h = gets.to_i
t = gets.chomp.upcase.gsub(/[^A-Z]/){ "[" }

mast = Array.new
h.times do
    row = gets.chomp
    mast.push( row )
end

#STDERR.puts rows

#puts t
res = Array.new
mast.each{ res.push("") }
t.split("").each{
    |c|
    pos=l*(c.ord-"A".ord);
    0.upto(h-1).each{ 
        |i| 
        res[i]+= mast[i][pos..(pos+l-1)]
    }
}

puts res
