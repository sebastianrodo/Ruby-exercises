class Factorial
  def self.calculate_factorial(number:)
    number == 0 ? 1 : (1..number).reduce(:*).to_i
  end
end


