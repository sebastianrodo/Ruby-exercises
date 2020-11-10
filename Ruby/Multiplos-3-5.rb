puts "Los multiplos de 3 y 5 son :"
puts (1...1000).to_a.select{|x| x if (x % 3 == 0 || x % 5 == 0) }
puts "La suma de los multiplos de 3 y 5 es :"
puts (1...1000).to_a.select{|x| x if (x % 3 == 0 || x % 5 == 0) }.sum
