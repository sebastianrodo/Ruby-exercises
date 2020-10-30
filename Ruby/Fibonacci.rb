a = 0
b = 1

puts "La secuencia de Fibonacci es la siguite hasta antes del valor de los 4 millones :"

while b <= 4000000
    x = a+b
    a = b
    b = x

    if b <= 4000000
        puts "#{b}"
    end
    
end