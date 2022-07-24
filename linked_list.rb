
class LinkedList
  
  attr_accessor :head, :tail

  def initialize(root_node = nil)
  	@head = root_node
  	@tail = root_node
  end

  def append(value)
  	new_node = Node.new(value, nil, @tail)
  	@tail.next_node = new_node
  	@tail = new_node
  end

  def prepend(value)
  	new_node = Node.new(value)
  	new_node.next_node = @head
  	@head.prev_node = new_node
  	@head = new_node
  end

  def size
  	count = 1
  	current = @head
  	while(!current.next_node.nil?)
  	  count += 1
  	  current = current.next_node
  	end
  	count
  end

  def at(index)
  	i = 0
  	current = @head
  	while current != nil
  	  return current if i == index
  	  i += 1
  	  current = current.next_node
  	end
  	return nil
  end

  def pop
  	@tail = @tail.prev_node
  	@tail.next_node = nil
  end

  def contains?(val)
  	current = @head
  	while current != nil
  	  return true if current.value == val
  	  current = current.next_node
  	end
  	return false
  end

  def find(val)
  	current = @head
  	count = 0
  	while !current.nil?
  	  return count if current.value == val
  	  current = current.next_node
  	  count += 1
  	end
  	return nil
  end

  def to_s
  	output = ""
  	current = @head
  	while !current.nil?
  	  output << "( #{current.value} ) -> "
  	  current = current.next_node
  	end
  	return output
  end

  def insert_at(val,index)
  	return if index <= 0 || index >= self.size-1
  	current = @head
  	count = 0
  	while count < index
  	  current = current.next_node
  	  count += 1
  	end
  	new_node = Node.new(val, current, current.prev_node)
  	current.prev_node.next_node = new_node
  	current.prev_node = new_node
  	return
  end

  def remove_at(index)
  	return if index <= 0 || index >= self.size-1
	current = @head
  	count = 0
  	while count < index
  	  current = current.next_node
  	  count += 1
  	end
  	current.prev_node.next_node = current.next_node
  	current.next_node.prev_node = current.prev_node
  	return
  end

end


class Node
  attr_accessor :value, :next_node, :prev_node
  def initialize(value = nil, next_node = nil, prev_node = nil)
  	@value = value
  	@next_node = next_node
  	@prev_node = prev_node
  end
end

