#!/usr/bin/ruby
l, c = gets.split(" ").map(&:to_i)
rows = Array.new
l.times { rows.push( gets.chomp ) }
rows.each{ |r| STDERR.puts r}

x, y = 0, 0
0.upto(l-1).each{ |i| s=rows[i].index("@"); if !s.nil? then x=s;y=i end } 

teleps = Array.new
0.upto(l-1).each{ |i| s=rows[i].index("T"); if !s.nil? then teleps.push([s,i]) end } 

dir = "SOUTH"

prios = 
[["SOUTH", "EAST", "NORTH", "WEST"],
 ["WEST", "NORTH","EAST","SOUTH"]]
#[{ "SOUTH" => "EAST", "EAST" => "NORTH", "NORTH" => "WEST", "WEST" => "SOUTH" },
# { "WEST"  => "NORTH","NORTH"=> "EAST", "EAST"=>"SOUTH", "SOUTH"=>"WEST" } ]
pn = 0
br = 0

steps = {   "SOUTH"=>{"x"=>0,"y"=>1},
            "NORTH"=>{"x"=>0,"y"=>-1},
            "WEST"=>{"x"=>-1,"y"=>0},
            "EAST"=>{"x"=>1,"y"=>0}
        }

states = Hash.new

#p [x,y]
#p rows[y][x]

res = Array.new

verz = 0;

loop do
    marker = x.to_s + "_" + y.to_s + "_" + pn.to_s + "_" + br.to_s + "_" + verz.to_s + "_" + dir
    #STDERR.puts(marker)
    if states.key?( marker ) then
        res = ["LOOP"]
        break
    end
    states[marker] = 1
    case rows[y][x]
        when "$"
            break
        when "I"
            pn = 1 - pn
        when "#"
            STDERR.puts "Fatal error!"
            break
        when "X"
            if br == 0 then
                STDERR.puts "Fatal error!"
                break               
            end
            rows[y][x] = " "
            verz += 1
        when "S"
            dir = "SOUTH"
        when "N"
            dir = "NORTH"
        when "W"
            dir = "WEST"
        when "E"
            dir = "EAST"
        when "B"
            br = 1 - br
        when "T"
            if x == teleps[0][0] && y == teleps[0][1] then
                x,y = teleps[1]
            else
                x,y = teleps[0]
            end
    end
    
    nx, ny = x + steps[dir]["x"], y + steps[dir]["y"]
    if rows[ny][nx] == "#" || br == 0 && rows[ny][nx] == "X" then
        prios[pn].each{ |ndir| 
            nx, ny = x + steps[ndir]["x"], y + steps[ndir]["y"]
            dir = ndir
            break unless rows[ny][nx] == "#" || br == 0 && rows[ny][nx] == "X"
        }
    end
    res.push( dir )
    #STDERR.puts( dir )
    x, y = nx, ny
end

puts res
