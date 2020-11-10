def sum_square_difference
  sum_of_squares = (1..100).map { |n| n ** 2 }.sum
  square_of_sums = (1..100).sum ** 2
  square_of_sums - sum_of_squares 
end

puts "The difference between the sum of the squares of the first one hundred natural numbers and the square of the sum is : #{sum_square_difference}"

