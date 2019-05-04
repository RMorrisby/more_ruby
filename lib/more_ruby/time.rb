
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