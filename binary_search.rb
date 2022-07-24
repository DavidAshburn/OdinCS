=begin
	
sorted array -> list

repeat until subarray size == 0
	calc midpoint
	if target == list[midpoint] stop

	if target < list[midpoint]
		search list[0...midpoint]
	else
		search list[midpoint..-1]
=end


def my_bin_search(list, target) #iterative
	while list.length > 1
		middle = list.length / 2
		midval = list[middle]
		return true if target == midval
		list = list[0...middle] if midval > target
		list = list[middle..-1] if midval < target
	end
	return list[0] == target ? true : false
end


list = [1,2,3,4,5,6,7,8,9]

#(0..12).each { |i| p "#{i} is #{my_bin_search(list,i)} "}

#Binary search trees

class BinaryTree
  attr_accessor :root
  def initialize(node)
    @root = node
  end

  def find(val)
  	return true if root.value == val
  	return df_find_helper(root,val)
  end

  def df_find_helper(node, value) #depth-first recursive traversal ( Preorder )
  	return if node.nil?
  	return true if node.value == value
  	return true if find_helper(node.left, value)
  	return true if find_helper(node.right, value)
  end

  def printout
	queue = [@root]
  	bf_print_helper(queue)
  end

  def bf_print_helper(queue) #level-order traversal
  	p queue[0].value
  	if !queue[0].left.nil? 
  		queue.push(queue[0].left)
  	end
  	if !queue[0].right.nil? 
  		queue.push(queue[0].right)
  	end
  	queue.shift
  	if queue.length > 0
  		bf_print_helper(queue) 
  	end
  end

end

class Node
  attr_accessor :left, :right, :value
  def initialize(left=nil,right=nil,value=nil)
	  @left = left
	  @right = right
	  @value = value
  end

  def root_place(val)
    if val < @value 
      if @left.nil?
        @left = Node.new(nil,nil,val)
      else
        @left.root_place(val)
      end
    else
      if @right.nil?
        @right = Node.new(nil,nil,val)
      else 
        @right.root_place(val)
      end
    end
  end
end

set = [5, 7, 1, 15, 9, 2, 14, 8, 7, 3]

set_tree = BinaryTree.new(Node.new(nil,nil,set[0]))

set[1..-1].each do |val|
	set_tree.root.root_place(val)
end

set_tree.printout