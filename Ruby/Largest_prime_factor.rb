require 'prime'

NUMBER = 600851475143

def largest_prime_factor
  Prime.prime_division(NUMBER).to_h.keys.each {|x| x}.max
end

puts "The largest prime factor of #{NUMBER} is : #{largest_prime_factor}"

