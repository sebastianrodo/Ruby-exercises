def largest_palindrome
  (100..999).each_with_object([]) do |x, array|
    (100..999).each do |y| 
      multiplication = x * y;
      array << multiplication if multiplication.to_s === multiplication.to_s.reverse
    end
  end.max
end

puts "The largest palindrome is : #{largest_palindrome}"

=begin
def largest_palindrome
    array = []
  
    (100..999).each do |x|
      (100..999).to_a.select {|i| a = x * i; array << a if a.to_s === a.to_s.reverse}
    end 
  
    print "The largest palindrome is : #{array.max}"
end
  
puts largest_palindrome

=end
  
