puts "¡Ingrese el valor al cual le quiere sacar el factorial!"

x = gets.chomp.to_i
if x == 0
    "Valor factorial igual a 0"
else
    puts "El valor factorial es:"
    puts (1).upto(x).reduce(:*)
end