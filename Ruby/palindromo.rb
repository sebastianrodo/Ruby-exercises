def largest_palindrome
    array = []
  
    (100..999).each do |x|
      (100..999).to_a.select {|i| a = x * i; array << a if a.to_s === a.to_s.reverse}
    end 
  
    print "The largest palindrome is : #{array.max}"
  end
  
    puts largest_palindrome
    
    
  
  =begin
  y = []
  (100..999).each do |x|
      (100..999).each do |i|
          a = x * i 
          if ( a.to_s === a.to_s.reverse)
              y.push(a)
          end
      end
  end 
  puts y.max
  =end
  