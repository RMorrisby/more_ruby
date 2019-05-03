require 'bigdecimal'

class String

    # .capitalize will upcase the first letter and lowercase everything else; this method does only the upcase part
    def capitalize_first_letter_only
        return self if empty?
        return self[0].upcase + self[1 .. -1] # self[1 .. -1] will return "" if self is only one character long
    end

    # Returns new string, does not modify in place
    def escape
        Regexp.escape(self)
    end

    # Returns a new string with each character's case randomised
    def random_case
        new = ""
        self.each_char do |x|
            new << ((rand(2) % 2 == 0) ? x.upcase : x.downcase)
        end
        new
    end

    def underbarize
        gsub(/[^a-zA-Z0-9]+/, '_')
    end

    def underbarize_and_downcase
        downcase.underbarize
    end

    # Like camelcase but with the first letter also capitalised
    # Pascalcase is C#'s case convention
    def pascalcase
        downcase.scan(/[a-z0-9]+/).map { |x| x.capitalize }.join
    end

    def camelcase
        s = self.pascalcase
        s[0].downcase + s[1 .. -1]
    end

    def append(s)
        self << s
    end

    def join(s = "")
        append(s)
    end

end

class Array
    # Does the array contain any of the supplied items?
    def include_any?(*items)
        items.each do |i|
         return true if self.include? i
        end
        false
    end    

    # Return a random item from the array (by index)
    def random
        self[rand(size)]
    end
    
    # Deletes at a random index from the array, and returns the deleted item
    def delete_random
        index = rand(size)
        item = self[index]
        delete_at(index)
        item
    end

    # Returns the mean / average of the Numeric array. Returns a float. All entries must be Numeric.
    def mean
        each {|item| raise TypeError, "Cannot determine the mean of an array that contains non-Numeric objects." unless item.kind_of?(Numeric)}
        inject{ |sum, item| sum + item }.to_f / size
    end
    alias :av :mean

    # Returns the summation of the contents of the array
    # Ignores nils; raises if the array contains a non-Numeric non-nil
    def sum
        raise TypeError, "Array contained non-numeric non-nil elements; cannot sum contents." unless compact.all_kind_of? Numeric
        compact.inject(0) do |sum, item| 
            sum += item 
        end
    end

    # Will insert each member of the supplied array into self, such that self does not contain a new sub-array
    # Insertion behaviour is more like += than << , e.g. [1, 2, 3].insert_flat(0, [4, 5]) => [4, 5, 1, 2, 3]
    # Does not flatten self, so any preexisting subarrays are preserved
    def insert_flat(index, o)
        case o
        when Array
            # A -ve insertion index inserts items AFTER the item at that index, which causes problems when inserting multiple times
            # Use o.each when -ve ; o.reverse_each when +ve or zero
            if index < 0
                o.each do |item|
                    insert(index, item)
                end
            else
                o.reverse_each do |item|
                    insert(index, item)
                end
            end
        else
            insert(index, o)
        end
    end

    # A simple method to fetch the item at the index. If index > size, then it 'wraps' around and looks again
    # E.g. [0, 1, 2].wrap_fetch(4) returns 1 
    # Operation is effectively fetch(index % size)
    def wrap_fetch(index)
        return nil if empty?
        fetch(index % size)
    end
    alias :modulo_fetch :wrap_fetch

    # Returns true if all elements of self are kind_of?(klass)
    def all_kind_of?(klass)
        all? {|item| item.kind_of?(klass)}
    end

    # Returns true if all elements of self are instance_of?(klass)
    def all_instance_of?(klass)
        all? {|item| item.instance_of?(klass)}
    end
end

class NilClass

    # A simple routing method in case your empty array is actually nil
    # If you're calling empty?, you care if there is data in there, not if the object is actually an array
    # nil is obviously empty, so return true instead of NoMethodError
    def empty?
        true
    end
end

class TrueClass

    # Yields true 50% of the time, otherwise yields false
    def random
        rand(2) % 2 == 0
    end

    def maybe?
        random
    end
end

class FalseClass

    # Yields true 50% of the time, otherwise yields false
    def random
        rand(2) % 2 == 0
    end

    def maybe?
        random
    end
end


class File
    # Returns the file's basename without its extension 
    def self.basename_no_ext f
        File.basename(f, File.extname(f))
    end
end

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


class Numeric

    # Returns a more print-friendly version of the number
    # e.g. 1234567.8901 => 1,234,567.8901
    # Returns a string
    # Copied from http://stackoverflow.com/questions/6458990/how-to-format-a-number-1000-as-1-000
    # Credit goes to user "loosecannon"
    def format_with_thousands_delimiter(delimiter = ",")
        parts = to_s.split(".")
        if parts.size == 2        
            parts[0].reverse.gsub(/...(?=.)/, '\&' + delimiter).reverse + "." + parts[1]
        else
            to_s.reverse.gsub(/...(?=.)/, '\&' + delimiter).reverse
        end
    end

end


class Time

    # Returns a new Time object with all subseconds set to zero
    def remove_subseconds
        ms = self.subsec
        self.clone - ms
    end

end