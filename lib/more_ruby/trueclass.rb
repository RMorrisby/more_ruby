
class TrueClass

    # Yields true 50% of the time, otherwise yields false
    def self.random
        rand(2) % 2 == 0
    end

    def self.maybe?
        random
    end
end