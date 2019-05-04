
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
