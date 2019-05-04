
class Fixnum

    # Converts the number (1 <= x <= 26) to a letter
    # 1 => A, 9 => I, 0 has no corresponding letter
    def num_to_letter
        raise "Do not call num_to_letter with a number that is not between 1 and 26" unless self >= 1 && self <= 26
        (self.to_i + 64).chr
    end
end