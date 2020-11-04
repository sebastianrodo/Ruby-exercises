puts "Ingrese alguna palabra la cual quiera saber si es palindroma"

x = gets.chomp.downcase

if (x === x.to_s.reverse) 
    puts "Si es una palabra palindroma"
else
    puts "No es una palabra palindroma"
end
