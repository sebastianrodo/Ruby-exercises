#Algoritmo que muestra los multiplos del 3 o del 5 
x = 0
result = 0
puts "Los siguientes números son losmultiplos de 3 y 5 :"
for i in 1...1000
	x += 1
	if x%3 == 0 || x%5 == 0
		puts  "#{x}"
		result += x
	end
end
 print "La suma de todos los multiplos de 3 o 5 por debajo de 1000 es de: #{result}"
