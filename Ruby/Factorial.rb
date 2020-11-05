puts "Enter the value for which you want to calculate the factorial!"

number = gets.chomp.to_i

def factorial(number)
  number == 0 ? "1" : (1..number).reduce(:*).to_s
end

puts "The factorial value is : " + factorial(number)