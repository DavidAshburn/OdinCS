class BalancedTree

  attr_accessor :root

public
  def initialize(list)
    @root = Node.new
    singles = []
    list.map { |v| singles.push(v) unless singles.include?(v) }
    singles.sort!
    @size = singles.length
    build_tree(@root, singles)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def contains?(seek)
    return true if root.value == seek
    return contains_helper(root,seek) ? true : false
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
    @size -= 1
  end
  
  def insert(value)
    if(!self.contains?(value))
      insert_helper(value, @root)
      @size += 1
      return true
    else
      return false
    end
  end

  def level_order(queue = [@root])
    count = 1
    dex = 0
    while(count < @size)
      if queue[dex].left != nil
        queue.push(queue[dex].left)
        count += 1
      end
      if queue[dex].right != nil
        queue.push(queue[dex].right)
        count += 1
      end
      dex += 1
    end

    if block_given? 
      i = 0
      while i < queue.length
        yield(queue[i])
        i += 1
      end
      return
    end
    return queue.map { |val| val.value }
  end

  def inorder(node = @root, list = [], &block)
    if !node.left.nil?
      inorder(node.left, list)
    end
    if block_given?
      block.call node
    else
      list.push(node.value)
    end
    if !node.right.nil?
      inorder(node.right, list)
    end
    return list
  end

  def preorder(node = @root, list = [], &block)
    if block_given?
      block.call node
    else
      list.push(node.value)
    end
    if !node.left.nil?
      preorder(node.left, list, &block)
    end
    if !node.right.nil?
      preorder(node.right, list, &block)
    end
    return list
  end

  def postorder(node = @root, list = [], &block)
    if !node.left.nil?
      postorder(node.left, list, &block)
    end
    if !node.right.nil?
      postorder(node.right, list, &block)
    end
    if block_given?
      block.call node
    else
      list.push(node.value)
    end
    return list
  end

  def height(node)
    if node.left.nil? && node.right.nil?
      return 0
    else 
      left = -1
      right = -1
      if !node.left.nil?
        left = height(node.left)
      end
      if !node.right.nil?
        right = height(node.right)
      end
      return left > right ? left + 1 : right + 1
    end
  end

  def depth(node)
    count = 0
    current = @root
    while(current != node)
      if current.value > node.value
        count += 1
        current = current.left
      elsif current.value < node.value
        count += 1
        current = current.right
      end
    end
    count
  end

  def balanced?
    if (height(@root.left) - height(@root.right)).abs > 1
      return false
    end
    return true
  end

  def rebalance
    new_list = inorder
    @root = Node.new
    new_list.sort!
    @size = new_list.length
    build_tree(@root, new_list)
  end

#private
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
    #returns leftmost node under a parent
    #using this for #delete and #depth
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

  def contains_helper(node, value) #depth-first recursive traversal ( Preorder )
    return if node.nil?
    return true if node.value == value
    return true if contains_helper(node.left, value)
    return true if contains_helper(node.right, value)
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
      return find_helper(seek, node.left)
    else
      return find_helper(seek, node.right)
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

rand_list = Array.new(15) { rand(1..100) }

rand_tree = BalancedTree.new(rand_list)

rand_tree.pretty_print

puts "Level Order\n"
puts rand_tree.level_order
puts "\n"
puts "PreOrder\n"
puts rand_tree.preorder
puts "\n"
puts "PostOrder\n"
puts rand_tree.postorder
puts "\n"
puts "InOrder\n"
puts rand_tree.inorder
puts "\n"

rand_tree.insert(105)
rand_tree.insert(250)
rand_tree.insert(134)
rand_tree.insert(165)
rand_tree.insert(785)

puts "Balanced? #{rand_tree.balanced?}\n"

rand_tree.rebalance
puts "Rebalancing..."

puts "Balanced? #{rand_tree.balanced?}\n"

rand_tree.pretty_print

puts "Level Order\n"
puts rand_tree.level_order
puts "\n"
puts "PreOrder\n"
puts rand_tree.preorder
puts "\n"
puts "PostOrder\n"
puts rand_tree.postorder
puts "\n"
puts "InOrder\n"
puts rand_tree.inorder
puts "\n"