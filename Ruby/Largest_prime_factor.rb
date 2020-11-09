require 'prime'

def largest_prime_factor
  Prime.prime_division(600851475143).to_h.keys.each {|x| x}.max
end

puts "The largest prime factor of 600851475143 is : #{largest_prime_factor}"

