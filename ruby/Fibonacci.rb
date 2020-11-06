
  def fibonacci2
    MAX_VALUE = 4000000

    (1..MAX_VALUE).each_with_object([1,2]) do |num, acum|
      return acum if acum[acum.size - 1] + acum[acum.size - 2] > MAX_VALUE 

      acum << acum[acum.size - 1] + acum[acum.size - 2]
    end
  end

  puts fibonacci2

=begin
  puts "The Fibonacci sequence is : "
  initial_variables = [0, 1]
   def(initial_variables)
       
   end
  
  (35).times do
    x = arry[0]+arry[1]
    arry[0]=arry[1]
    break if x>=4000000
    arry[1]=x
      puts arry[1]
  end
=end

=begin


def fibonacci(max_value)
    puts "The Fibonacci sequence is : "
  
    initial_value1 = 1
    initial_value2 = 1
   
    while initial_value2 <= max_value
      yield initial_value2
  
      final_value = initial_value1 + initial_value2
      initial_value1 = initial_value2
      initial_value2 = final_value 
    end
   
  end
   
  fibonacci(4000000) {|x| puts x }
=end
 
   
   