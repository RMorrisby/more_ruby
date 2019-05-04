
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
