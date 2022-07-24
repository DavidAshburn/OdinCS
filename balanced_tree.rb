class BalancedTree

  attr_accessor :root
  def initialize(list)
    @root = Node.new(0)
    @root.balance_out(list)
  end

  def printout
	queue = [@root]
  	output =  print_helper(queue, Array.new)
  	max = 0
  	output.each do |a,b|
  		puts "value: #{a} level:#{b}"
  	end
  end

  def print_helper(queue,output)
  	this = queue[0]
  	output << [this.value, this.level]
  	queue.push(this.left) if !this.left.nil? 
  	queue.push(this.right) if !this.right.nil? 
  	queue.shift
  	bf_print_helper(queue) if queue.length > 0
  	end
  	return output
  end
end

class Node
  attr_accessor :left, :right, :value
  def initialize(level, value=nil, left=nil,right=nil)
	  @left = left
	  @right = right
	  @value = value
	  @level = level
  end

  def balance_out(list)
  	middle = list.length/2
  	
  	self.value = list[list.length/2]


  end
end