#!/usr/bin/ruby
graph = Hash.new;
n = gets.to_i

n.times do
    x, y = gets.split(" ").map(&:to_i);
    #STDERR.puts( "--- " + x.to_s + " " + y.to_s );
    if graph[x].nil? then
        graph[x] = Array.new
    end
    graph[x].push( y );
end

class DfsTopologicalSort
    attr_reader :result
    def initialize( igraph )
        @igraph = igraph
        @tmark = Hash.new
        @pmark = Hash.new
        @ok = 1;
        @result = Array.new
        @igraph.keys.each{
            |x| if !@pmark.key?( x ) 
                visit( x );
            end
        }
    end
    
    def visit( node )
        # STDERR.puts("=== visit "+node.to_s)
        if @tmark.key?( node ) then
            @ok = 0;
            return; 
        end
        if @pmark.key?( node ) then
            return;
        end
        @tmark[node]=1
        if @igraph.key?( node ) then
            @igraph[node].each{ |x| visit(x) }
        end
        @pmark[node]=1
        @tmark.delete(node)
        @result.unshift(node)
    end
end


dfst = DfsTopologicalSort.new( graph )
#p dfst.result

dist = Hash.new
dfst.result.reverse.each{
    |node| dist[node] = if graph.key?( node ) 
                        then 1+graph[node].map{ |x| dist[x] }.max
                        else 1
                        end
}
#p dist

p dist.values.max
