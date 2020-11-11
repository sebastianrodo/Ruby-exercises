require 'prime'

PRIME_NUMBER_POSITION = 10001

def prime_number_max
  Prime.first(PRIME_NUMBER_POSITION).max
end

puts "The 10001 prime number is : #{prime_number_max}"

