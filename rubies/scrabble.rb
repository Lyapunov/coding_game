#!/usr/bin/ruby
n = gets.to_i
dict = Array.new
n.times{ dict.push( gets.chomp ) }
letters = gets.chomp.split("").group_by{|w|w}.map{|c,cs| [c,cs.size]}.to_h

def cpoint( c )
    return case c
            when "q","z"
                10
            when "j","x"
                8
            when "k"
                5
            when "f","h","v","w","y"
                4
            when "b","c","m","p"
                3
            when "d","g"
                2
            else
                1
            end
end

def wpoint( w )
   return w.split("").inject(0){ |res,c| res+=cpoint(c)} 
end

def scrabblable( w, let )
   wlet=w.split("").group_by{|w|w}.map{|c,cs| [c,cs.size]}.to_h
   if (wlet.keys - let.keys).any?
      return false  
   end
   faults = wlet.inject(0){ |res,o| res+=(let[o[0]] < o[1])?1:0 }
   if faults > 0 
      return false
   end
   return true 
end

#p scrabblable("hi",letters)
#p scrabblable("ha",letters)
#p scrabblable("hih",letters)
#p scrabblable("hihh",letters)

puts dict.max_by{ |w| scrabblable(w, letters)? wpoint(w) : -1 }
