class Travails
	attr_accessor :board
	def initialize(square)
		@board = Array.new { Array.new(8,false) }
		@root = Node.new(square[0], square[1])


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
		list.each do |i| 
			good_moves.push(i) unless i[0] > 7 || i[0] < 0 || i[1] > 7 || i[1] < 0 || @board[i[0]][i[1]]
		end
		good_moves.each { |i| @board[i[0]][i[1]] = true }
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
end

class Node

	def initialize(x = 0,y = 0,child_list = [])
		attr_accessor :x, :y, :child_list
		@x = x
		@y = y
		@child_list = child_list
	end

end