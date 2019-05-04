
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