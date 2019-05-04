

class Float

    # Two cases : self.abs >= 1, and self.abs < 1
    # If >= 1, we can use .round(), adjusting for the number of digits before the decimal point
    # If < 1, .round() will not ignore leading zeroes, so we have to use another means
    # There is another complication in that 0.00000766.to_s returns 7.66e-06 , not 0.00000766 as we would prefer here
    def signif(num_digits)
        raise TypeError, "Must call #{__method__} with an Integer" unless num_digits.kind_of?(Integer)
        raise ArgumentError, "Must call #{__method__} with a positive Integer" if num_digits < 0 # 0 is a special case, but allowed
        # Special cases
        return 0.0 if num_digits == 0
        return self if self == 0.0

        negative = self < 0 # remember its sign for later

        # Need to check to see if the numebr is small enough that to_s will put it into scientific notation
        if self.to_s =~ /^(\d)\.(\d*)e-(\d+)$/
            places = 1 + $2.size + $3.to_i             
            s = "%.#{places}f" % self # should print out 7.66e-06 as 0.00000766
        else
            s = self.to_s
        end
        parts = s.split(".")
        whole = parts[0].to_i.abs

        # significant figures ignore leading zeroes, so we can only return early here if self.abs > 1
        # 123.456.signif(4) should return 123.4; 123.456.signif(3) should return 123
        if whole != 0 # equivalent to self.abs > 1
            if num_digits <= whole.digit_count
                return whole.signif(num_digits).to_f 
            else
                return self.round(num_digits - whole.digit_count)
            end
        end

        fraction_as_s = parts[1] # keep as string for now
        return whole.signif(num_digits).to_f unless fraction_as_s # should not be possible, but check it anyway
        return whole.signif(num_digits).to_f if fraction_as_s == "0"

        relevant_fraction_digits = num_digits
        fraction = "0.#{fraction_as_s}".to_f
        fraction_as_s =~ /^([0]*)[1-9]/
        leading_zeroes_count = $1.size
        rounded_fraction = fraction.round(relevant_fraction_digits + leading_zeroes_count)
        if negative
            return -(rounded_fraction)
        else
            return rounded_fraction
        end
    end
end