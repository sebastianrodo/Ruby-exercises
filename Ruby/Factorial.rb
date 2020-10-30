puts "¡Porfavor digite el número al cuál quiere calcularle el valor factorial!"

i = 0
fac = 1
n = gets.chomp().to_i

if n == 0
    puts "El valor del número factorial es igual a 1"
else
    while i<n 
        i += 1
        fac *= i
        
    end
    puts "El valor factorial de #{n} es igual a : #{fac}"
end