require 'bigdecimal'

class Integer

    # Returns the number of digits in the number
    def digit_count
        self.to_s.size
    end

    # Code taken from https://www.ruby-forum.com/topic/187036 ; all credit for mechanism goes to Harry Kakueki
    # Method is same as Float#signif below; dangerous to add to common parent Numeric?
    def signif(num_digits)
        raise TypeError, "Must call #{__method__} with an Integer" unless num_digits.kind_of?(Integer)
        raise ArgumentError, "Must call #{__method__} with a positive Integer" if num_digits < 0 # 0 is a special case, but allowed
        return 0.0 if num_digits == 0
        return self if self.digit_count <= num_digits
        m = (num_digits - 1) - Math.log10(self.abs).floor
        BigDecimal.new(((self * 10 ** m).round * 10 ** (-1 * m)).to_s).to_s('F').gsub(/\.0*$/,"").to_i
    end
end