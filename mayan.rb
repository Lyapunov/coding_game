#!/usr/bin/ruby

#---------------------------------------------------------
# 1. read data
#---------------------------------------------------------
l, h = gets.split(" ").collect {|x| x.to_i}
@digits=Array.new
(0..19).each{|x| @digits[x]=Array.new}
h.times do
    diglines = gets.chomp.scan(/.{1,#{l}}/)
    (0..19).each{|x| @digits[x].push(diglines[x]) }
end
s1 = gets.to_i
num1=Array.new
(0..(s1 / h - 1)).each{
    |x| num1[x] = Array.new
    (1..h).each{ num1[x].push(gets.chomp) }
}
s2 = gets.to_i
num2=Array.new
(0..(s2 / h - 1)).each{
    |x| num2[x] = Array.new
    (1..h).each{ num2[x].push(gets.chomp) }
}
oper = gets.chomp

#---------------------------------------------------------
# Convert mayan to number
#---------------------------------------------------------
def mdig_to_n(mdig)
    for i in 0..19   
       if mdig == @digits[i] 
           return i
       end 
    end
    return 0
end

def m_to_n(m)
   mds = m.map{|md| mdig_to_n( md ) }
   base = 1;
   return mds.reverse.inject(0){|res,d| res+=d*base;base*=20;res}
end

#p num1
#p m_to_n(num1)
#p num2
#p mdig_to_n(num2[0])
instr=m_to_n(num1).to_s + oper + m_to_n(num2).to_s
#p instr
res=eval(instr).to_i

#---------------------------------------------------------
# Convert number to mayan was easier
#---------------------------------------------------------
ri = res.to_s(20).scan(/./).map{|c| c.to_i(20)}

ri.each{|n|puts @digits[n]}
