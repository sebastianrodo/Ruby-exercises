
def difference
  sum_of_squares = (1..100).map { |n| n ** 2 }.sum
  square_of_sum = (1..100).sum ** 2
  sum_of_squares - square_of_sum
end

puts "The difference between the sum of the squares of the first one hundred natural numbers and the square of the sum is : #{difference}"

