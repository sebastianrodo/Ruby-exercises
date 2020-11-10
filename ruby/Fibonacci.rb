MAX_VALUE = 4000000
def fibonacci2
  (1..MAX_VALUE).each_with_object([1,2]) do |num, acum|
    final_value = acum[acum.size - 1] + acum[acum.size - 2]
    return acum if final_value > MAX_VALUE 

    acum << final_value
  end
end

puts "The Fibonacci sequence is: #{fibonacci2}"

