
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

  def bf_print_helper(queue) #level-order recursive traversal
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