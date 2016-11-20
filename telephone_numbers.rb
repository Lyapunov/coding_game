class Node
    def initialize()
        @children = Hash.new
    end
    def _add_num_arr(nums)
        if !nums.empty?
            first, *rest = nums
            # p first, rest
            if !@children.has_key?( first )
               @children[first]=Node.new()
            end
            @children[first]._add_num_arr( rest ) 
        end
    end
    def add_number(str)
        _add_num_arr(str.scan(/./))
    end
    def num_of_nodes()
        return @children.inject(0){|m,n| m+=n[1].num_of_nodes()+1 }
    end
end

root = Node.new()

n = gets.to_i
n.times do
    tel = gets.chomp
    root.add_number( tel )
    # p tel
end

p root.num_of_nodes()
