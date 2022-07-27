class BalancedTree

  attr_accessor :root

public
  def initialize(list)
    @root = Node.new
    singles = []
    list.map { |v| singles.push(v) unless singles.include?(v) }
    singles.sort!
    build_tree(@root, singles)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def contains?(val)
    return true if root.value == val
    return contains_helper(root,val) ? true : false
  end

  def find(seek)
    if contains?(seek)
      return find_helper(seek)
    else return nil
    end
  end

  def delete(val)
    if(val == @root.value)
      #get parent to clear child leaf and child leaf to replace @root value
      pair = targets(leftmost_child(@root.right).value)
      @root.value = pair[1].value

      if pair[0].left != nil
        pair[0].left = nil if pair[0].left.value == val
      end
      if pair[0].right != nil
        pair[0].right = nil if pair[0].right.value == val
      end
      return
    end
    
    branch = targets(val)

    #node to delete is a leaf with no children
    if branch[1].left == nil && branch[1].right == nil
      branch[0].right = nil if branch[0].right == branch[1]
      branch[0].left = nil if branch[0].left == branch[1]
    #node to delete has two children
    elsif branch[1].left != nil && branch[1].right != nil
      repl_node = leftmost_child(branch[1].right)
      self.delete(repl_node.value)
      branch[1].value = repl_node.value
    #node to delete has one child
    else
      if branch[1].value < branch[0].value
        branch[0].left = only_child(branch[1])
      else
        branch[0].right = only_child(branch[1])
      end
    end
  end
  
  def insert(value)
    if(!self.contains?(value))
      insert_helper(value, @root)
      return true
    else
      return false
    end
  end

private
  def build_tree(node,list)
    middle = list.length/2
    node.value = list[middle]
    if middle > 0
      left_list = list[0...middle]
      right_list = list[middle+1..-1]
      node.left = Node.new
      node.right = Node.new
      build_tree(node.left,left_list)
      build_tree(node.right,right_list)
      node.left = nil if node.left.value == nil
      node.right = nil if node.right.value == nil
    else
      return
    end
    return
  end

  def contains_helper(node, value) #depth-first recursive traversal ( Preorder )
    return if node.nil?
    return true if node.value == value
    return true if contains_helper(node.left, value)
    return true if contains_helper(node.right, value)
  end

  def targets(seek, node = @root) 
    #returns [parent_node, matching_node]
    #using this for delete operations
    if node.left.value == seek
      return [node, node.left]
    end 
    if node.right.value == seek
      return [node, node.right]
    end
    if seek >= node.value 
      return targets(seek, node.right)
    else
      return targets(seek, node.left)
    end
  end
  
  def leftmost_child(node)
    #returns leftmost(lowest value) node under a parent
    #using this for delete on nodes with two children
    if node.left == nil
      return node
    else return leftmost_child(node.left)
    end
  end

  def only_child(node)
    #returns child of node with a single child
    return node.left if node.left != nil
    return node.right if node.right != nil
  end

 def insert_helper(value, node)
    if(value < node.value)
      if node.left == nil
        node.left = Node.new(value) 
      else
        insert_helper(value,node.left)
      end
    else
      if node.right == nil
        node.right = Node.new(value) 
      else
        insert_helper(value,node.right)
      end
    end
  end

  def find_helper(seek, node = @root)
    if node.value == seek
      return node
    elsif seek < node.value
      return find(seek.node.left)
    else
      return find(seek.node.right)
    end
  end
end

class Node
  attr_accessor :left, :right, :value
  def initialize(value=nil, left=nil,right=nil)
	  @left = left
	  @right = right
	  @value = value
  end
end

set = [1,2,6,4,3,7,8,9,10,3,2,6]

my_tree = BalancedTree.new(set)
my_tree.pretty_print
puts "\n"

my_tree.delete(6)

my_tree.pretty_print

found = my_tree.find(7)

p found