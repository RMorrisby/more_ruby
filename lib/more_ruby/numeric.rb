
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
