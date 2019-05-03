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

    def capitalize_all
        downcase.scan(/[a-z0-9]+/).map { |z| z.capitalize }.join(' ')
    end

    def invert_case
        s = ""
        self.chars do |c|
            if c =~ /[A-Z]/
                s << c.downcase
            elsif c =~ /[a-z]/
                s << c.upcase
            else
                s << c
            end            
        end
        raise "invert_case failed!" unless s.size == self.size
        s
    end

    # Prefixes each line with the supplied string
    def prefix_lines(prefix)
        gsub(/^/) { prefix }
    end

    # Remove leading whitespace from each line in the string, using the indentation of the first line as the guide
    def unindent
        leading_whitespace = self[/\A\s*/]
        self.gsub(/^#{leading_whitespace}/, '')
    end

    # Returns the index of the last capital in the string (if one exists)
    def index_of_last_capital
        pos = 0
        reverse_index = self.reverse.index /[A-Z]/
        return nil if reverse_index == nil
        self.size - reverse_index - 1
    end

    def snakecase
        gsub(/[^a-zA-Z0-9]+/, '_')
    end

    def snakecase_and_downcase
        downcase.snakecase
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

    # Converts aStringInCamelCase to a_string_in_camel_case
    def camelcase_to_snakecase
        a = []

        self =~ /(^[a-z]+)/
        a << $1 if $1

        m = self.scan /([A-Z]+[a-z0-9]*)/
        m.flatten!
        m.each do |fragment|
            fragment =~ /([A-Z]+[a-z0-9]*)/
            caps = $1
            lower = $2
            if caps.size > 1
                s = "_#{caps.downcase}"
                a << s
                caps = "" # set to empty string so that the below caps.downcase still works
            end
            s = "_#{caps.downcase}#{lower}"
            a << s unless s == "_"
        end
        a.join
    end

    def append(s)
        self << s
    end

    def join(s = "")
        append(s)
    end

    def to_bool
        return true if self.downcase == "true"
        return false if self.downcase == "false"
        raise "String #{self} was neither 'true' nor 'false'. Cannot convert to boolean in this custom method."
    end

    # Does the string look like an integer?
    # !! will convrt nil to false, and anythig else (e.g. 0) to true
    def is_integer?
        !!(self =~ /^[0-9]+$/)
    end

    # Does the string look like hex?
    # !! will convrt nil to false, and anythig else (e.g. 0) to true
    def is_hex?
        !!(self =~ /^[0-9a-fA-F]+$/)
    end

    def formatted_number(separator = ",", count_limit = 3)
        copy = self.dup
        s = ""
        count = 0
        while copy.size > 0
            if count == count_limit
                s << separator
                count = 0
            else
                count += 1
                s << copy[-1]
                copy.chop!
            end
        end
        s.reverse
    end

    # Take the XML-string and remove from it anything that looks like an XML tag
    def extract_values_from_xml_string
        values = []
        a = self.split("<").collect { |z| z.chomp } # need to remove whitespace where possible
        # Now remove from the array any items that end in a > - these items look like fragments of tags
        a.delete_if { |z| z =~ />$/ }

        # a might now contain nils, "" and items like "foo>bar"
        a.delete_if { |z| z == "" }
        a.compact!
        a.each { |z| values << z.split(">")[1] }

        values
    end

    # Within the string, whitespace chars (\n, \r, \t) are replaced by their text equivalents, e.g. \n => \\n
    # Does not modify self
    def escape_whitespace
        copy = self.dup
        copy.gsub!("\n", "\\n")
        copy.gsub!("\r", "\\r")
        copy.gsub!("\t", "\\t")
        copy
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

    def random_index
        rand(size)
    end

    # Insert the supplied element to a random position within the array
    def random_insert(element)
        insert(rand(size), element)
    end

    # Move a random element to a random position in the array
    def random_move(times = 1)
        times.times do
            element = delete_random
            random_insert(element)
        end
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

    # A prettier way of printing an array
    # Want to p each row, but have each p appear on a new line in STDOUT
    def peach
        self.each { |z| p z }
    end

    # Method to convert all values to strings, for all layers within the array
    def stringify_all_values_deep
        for i in 0 ... size do
            v = self[i]
            case v
            when Array, Hash
                v = v.stringify_all_values_deep
            else
                v = v.to_s
            end
            self[i] = v
        end
        self
    end

end


class Hash

    # Method to convert all values to strings, for all layers within the hash
    def stringify_all_values_deep
        self.each_pair do |k, v|
            case v
            when Array, Hash
                v = v.stringify_all_values_deep
            else
                self[k] = v.to_s
            end
        end
        self
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
    def self.random
        rand(2) % 2 == 0
    end

    def self.maybe?
        random
    end
end

class FalseClass

    # Yields true 50% of the time, otherwise yields false
    def self.random
        rand(2) % 2 == 0
    end

    def self.maybe?
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

class Fixnum

    # Converts the number (1 <= x <= 26) to a letter
    # 1 => A, 9 => I, 0 has no corresponding letter
    def num_to_letter
        raise "Do not call num_to_letter with a number that is not between 1 and 26" unless self >= 1 && self <= 26
        (self.to_i + 64).chr
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

    # Method to compare self against other_time, returning true if self is equal to or earlier/before other_time
    # This comparison is made with some leeway, so that if self is actually after other_time, but by less than
    # the leeway amount (in seconds), the method will return true
    def is_before?(other_time, leeway = 5)
        other_time += leeway
        self <= other_time
    end

    # Method to compare self against other_time, returning true if self is equal to or later/after other_time
    # This comparison is made with some leeway, so that if self is actually before other_time, but by less than
    # the leeway amount (in seconds), the method will return true
    def is_after?(other_time, leeway = 5)
        other_time -= leeway
        self >= other_time
    end

    # Method to compare self against other_time, returning true if it is close enough to self in either direction
    # Leeway is in seconds
    def is_within?(other_time, leeway = 5)
        is_before?(other_time, leeway) && is_after?(other_time, leeway)
    end
end

module Enumerable
    def group_by
        result = {}
        self.each do |value|
            key = yield(value)
            (result[key] ||= []) << value
        end
        result
    end
end
