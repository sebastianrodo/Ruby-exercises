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