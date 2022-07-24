
rocks = 30.times.map{rand(200) + 1}
max_rock = 0

rocks.each { |rock| max_rock = rock if max_rock < rock }

#instead of a loop, we can define a method that accepts one argument, an array of values

# - if the array has two values or fewer, return the largest of the two
# - if the array has > 2 values, split it into two arrays. Then invoke the method two more times to handle each sub array


#dont run this its too bad on memory
def rock_sorter(pile)
  if pile.length == 2
    a = pile[0]
    b = pile[1]
  else
    a = rock_sorter(pile.slice!(0,pile.length/2))
    b = rock_sorter(pile)
  end
  return a > b ? a : b
end

#puts "Heaviest judger is: #{rock_sorter(rocks)}"
#I get a stack error with 30 rocks lololololol


#n! = 1 * 2 * 3 * 4 * 5...n
# fact(n) = n * fact(n-1)
def factorial(n)
  if n == 1
    return 1
  else
    return n * factorial(n-1)
  end
end

=begin
The Collatz conjecture

if n is 1, stop
Otherwise, if n.even? n/2
Otherwise, if n.odd? 3n+1
=end

$collatz = 0

def Collatz(val)
  if val == 1
    $collatz += 1
    return 1
  elsif val.even?
    $collatz += 1
    return Collatz(val / 2)
  else
    $collatz += 1
    return Collatz((val * 3) + 1)
  end
end

def fibs(val)
  list = [0,1]
  if(val > 2)
    (val-2).times { list.push(list[-2]+ list[-1]) }
  end
  list
end

def fibs_rec(val)
  return val < 2 ? val : fibs_rec(val-2) + fibs_rec(val-1)
end

def fibonacci(val)
  list = []
  val.times { |i| list.push(fibs_rec(i)) }
  return list
end

#Merge Sort

def mergesort(array)
  return array if array.length == 1
  middle = array.length/2
  merge mergesort(array[0...middle]), mergesort(array[middle..-1])
end

def merge(left,right)
  result = []
  until left.length == 0 || right.length == 0 do
    result << (left.first <= right.first ? left.shift : right.shift)
  end
  result + left + right
end


p mergesort([4,2,5,6,3,1,8,7,9,4])

