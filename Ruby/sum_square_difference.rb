c = 0
def difference(c)
  a = (1..100).map { |n| n ** 2 }.sum
  b = (1..100).sum ** 2
  c = b - a
end

puts "The difference between the sum of the squares of the first one hundred natural numbers and the square of the sum is :"
puts difference(c)