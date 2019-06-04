
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

    # Changes every sequence of non-alpha-numeric characters to underscores
    # If you want to convert something looking like camelcase to snakecase, 
    # use snakecase
    def snakecase_non_alpha
        gsub(/[^a-zA-Z0-9]+/, '_')
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
    # Also converts SomeStringInPascalCase to some_string_in_pascal_case
    #a << {:raw => "thiNGS-with_stuff", :expected => "thi_ngs_with_stuff"}
    def snakecase
        # Notes : 
        # If the entire string contains only uppercase (with or without underscores), return it as it is
        if self =~ /^[A-Z_]+$/
            return self
        end

        # If the entire string contains only uppercase and numbers, AND has underscores, return it as it is
        # REQ_ID2 -> REQ_ID2 ; REQID2 should not -> REQID2
        if self =~ /^[A-Z0-9_]+$/ && self.include?("_")
            return self
        end

        a = []

        before = self.snakecase_non_alpha
        parts = before.split("_")
        
        # Process each part, then stitch them back together
        # Each part might itself contain several 'camel humps' 
        # Each fragment within each part might be of different 'format'

        parts.each do |part|
            # If the part is already all lowercase, keep it and move on to the next part
            part =~ /^([a-z0-9]+)$/
            if $1
                a << $1
                next
            end
            
            # ABC -> ABC # if all capitals, leave it as it is
            # If the part is already all uppercase, keep it and move on to the next part
            part =~ /^([A-Z]+)$/
            if $1
                a << $1
                next
            end

            #
            # The part contains 'camel humps', which need to be processed
            #

            # Make sure to preserve the leading part of the string before the first 'hump'
            part =~ /^([a-z0-9]+)([A-Z])/
            if $1
                a << $1
            end

            # This scan-regex will only match from the first 'hump' onwards
            fragments = part.scan /([A-Z]+[a-z0-9]*)/
            fragments.flatten!
            fragments.each do |fragment|

                # ABCD -> abcd
                fragment =~ /^([A-Z]+)$/
                if $1
                    a << $1.downcase
                    next
                end

                # ABCD1234 -> abcd_1234
                fragment =~ /^([A-Z]+)([0-9]+)$/
                if $1
                    a << $1.downcase
                    a << $2
                    next
                end
                
                # Abc -> abc
                fragment =~ /^([A-Z][a-z0-9]*)$/
                if $1
                    a << $1.downcase
                    next
                end
                
                # ABCDef -> abc_def
                fragment =~ /^([A-Z]+)([A-Z][a-z0-9]*)$/
                if $1
                    a << $1.downcase
                    a << $2.downcase
                    next
                end

            end # end fragments
        end # end parts
        s = a.join("_")

        # Final tidying
        s.gsub!(/[_]+/, "_") # replace continuous underscores with one underscore
        s = s[1 .. -1] if s[0] == "_" # a pascalcase string will cause a leading underscore, which we need to remove
        s
    end

    def snakecase_and_downcase
        self.snakecase.downcase
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
