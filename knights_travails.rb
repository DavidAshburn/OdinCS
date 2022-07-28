class Travails
	attr_accessor :board, :root
	def initialize(start_x, start_y)
		@root = Node.new(start_x, start_y)
		@board = Array.new(8) { Array.new(8, false) }
		@queue = [@root]
		build_tree
	end

	def knight_moves(start_x, start_y) #returns array of valid, new squares to move to format [x,y]
		a = [start_x + 1, start_y + 2]
		b = [start_x + 2, start_y + 1]
		c = [start_x - 1, start_y + 2]
		d = [start_x - 2, start_y + 1]
		e = [start_x + 1, start_y - 2]
		f = [start_x + 2, start_y - 1]
		g = [start_x - 1, start_y - 2]
		h = [start_x - 2, start_y - 1]

		candidates = [a,b,c,d,e,f,g,h]
		valids = candidates.reduce([]) do |valids, candidate| #clear visited and invalid squares @board tracks visited squares
			if (candidate[0] < 8 && candidate[0] >= 0 && candidate[1] < 8 && candidate[1] >= 0 && @board[candidate[0]][candidate[1]] == false)
				valids.push(candidate)
			end
			valids
		end
		valids.each { |pair| @board[pair[0]][pair[1]] = true }
		return valids
	end

	def one_from_queue #populates children and routes of one queue item, build tree controls loop condition
		new_moves = knight_moves(@queue[0].x_coord, @queue[0].y_coord)
		init_nodes = []
		new_moves.each do |x|
			init_nodes.push(Node.new(x[0], x[1]))
		end
		init_nodes.each do |x| #this will copy the parent routes, add the parent, and assign to each child, then add children to queue and to parent
			this_route = []
			@queue[0].route.each { |x| this_route.push(x) }
			this_route.push([@queue[0].x_coord, @queue[0].y_coord])
			x.route = this_route
			@queue.push(x)
			@queue[0].children.push(x)
		end
		@queue.shift
	end

	def get_route(list) #run through all nodes in level order until one matches target, return the stored route made on initialization
		line = [@root]
		
		while line.length > 0
			if line[0].x_coord == list[0] && line[0].y_coord == list[1]
				line[0].route.push([list[0],list[1]])
				return line[0].route
			else
				line[0].children.each { |x| line.push(x) }
				line.shift
			end
		end
		return "oops"
	end

	def build_tree #loop control for one_from_queue
		while @board.flatten.all? == false
			one_from_queue
		end
	end

	def coord_to_chess(pair) #returns string like 'A4'
		return "#{(pair[0] + 'A'.ord).chr}#{(pair[1] + '1'.ord).chr}"
	end

	def chess_to_coord(string) #returns [x,y] coords (0..7)
		pair = string.split('')
		x = pair[0].ord - 'A'.ord
		y = pair[1].ord - '1'.ord
		return [x,y]
	end

	def input_square(string) #controller
		pair = chess_to_coord(string)
		output = get_route(pair)
		output.each do |x|
			puts coord_to_chess(x)
		end
	end
end

class Node
	attr_accessor :x_coord, :y_coord, :children, :route
	def initialize(x_coord = nil, y_coord = nil, route = [])
		@x_coord = x_coord
		@y_coord = y_coord
		@route = route
		@children = []
	end
end

game = Travails.new(3,3)

game.input_square("C4")