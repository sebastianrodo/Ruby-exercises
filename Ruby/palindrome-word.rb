puts "Ingrese alguna palabra la cual quiera saber si es palindroma"

x = gets.chomp.downcase

return puts "Es un palindrome" if x === x.to_s.reverse

puts "No es un palindrome"

