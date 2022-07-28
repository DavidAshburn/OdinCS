
class Node
	attr_accessor :x, :y, :parent, :child_list, :route
	def initialize(x = 0,y = 0, parent = nil)
		@x = x
		@y = y
		@parent = parent
		@child_list = []
		@route = []
	end
end

class Travails
	attr_accessor :board, :root, :routes
	def initialize(square)
		@board = Array.new(8) { Array.new(8, false) }
		@routes = Array.new { Array.new(8, nil) }
		@root = Node.new(square[0], square[1])
		build_tree(@root)
	end

	def knight_moves(x,y) #selects only valid moves that haven't been found yet
		a = [x+2,y+1]
		b = [x+1,y+2]
		c = [x-2,y+1]
		d = [x-1,y+2]
		e = [x+2,y-1]
		f = [x+1,y-2]
		g = [x-2,y-1]
		h = [x-1,y-2]
		list = [a,b,c,d,e,f,g,h]
		good_moves = []
		list.each do |i| #filter invalid moves and old squares
			x = i[0]
			y = i[1]
			good_moves.push(i) unless x > 7 || x < 0 || y > 7 || y < 0 || @board[x][y]
		end
		good_moves.each do |i| #mark off newly visited squares
			x = i[0]
			y = i[1]
			@board[x][y] = true
		end 
		good_moves
	end

	def chess(list) #converts [(0..7),(0..7)] into a string like 'A4'
		moves = []
		list.each do |i|
			string = (i[0] + 'A'.ord).chr
			string.concat((i[1] + '1'.ord).chr)
			moves.push(string)
		end
		puts moves
	end

	def chess_square(string) #converts a string like 'A4' into [(0..7),(0..7)]
		indexes = string.split('')
		col = indexes[0].upcase.ord - 'A'.ord
		row = indexes[1].to_i - 1
		return [col,row]
	end

	def build_tree(node)
		list = knight_moves(node.x,node.y)
		return if list.length == 0

		node.child_list = list.reduce([]) do 
			|reduction, x| reduction.push(Node.new(x[0],x[1],node))
		end
		if node.child_list.length > 0
			node.child_list.each do |x| 
				build_tree(x)
			end
		end
	end

	def level_order(queue = [@root]) #populates @routes if no block given
    	count = 1
    	dex = 0
    	while(count < 65)
    		queue[dex].child_list.each do |child|
    			queue.push(child)
    			count += 1
    		end
    		dex += 1
    	end

    	if block_given?
        	queue.each { |val| yield(val) } 
    	else
    		queue.each do |val|
    			val.route = trace(val)
    		end
    	end
  	end

  	def trace(node)
  		list = []
  		trace_helper(node,list)
  		return list
  	end

  	def trace_helper(node,list)
  		list.push([node.x, node.y])
  		if node.parent != nil
  			trace_helper(node.parent,list)
  		end
  		return
  	end

  	def get_route(pair)
  		level_order do |node|
  			if node.x == pair[0] && node.y == pair[1]
  				return node.route
  			end
  		end
 	end
end



game = Travails.new([4,4])

game.level_order

game.get_route([3,3]).each do |val|
	game.chess(val)
end
p game.get_route([3,3])

