
class Hash

    def random_value
        self.values.random
    end

    def random_key
        self.keys.random
    end

    # Returns a hash of the key and value
    def random_pair
        key = random_key
        {key => self[key]}
    end

    def delete_random
        delete(self.random_key)
    end

    # Gathers all keys in the hash in a flat array, even if it's multi-level    
    # E.g. from {:a => :b, :c => {:d => :e}}, returns [:a, :c, :d]
    def all_keys
        list = []
        self.each_pair do |k, v|
            case k
            when Hash
                list += k.all_keys
            when Array
                if k[0].class == Hash # if the array contains hashes
                    k.each do |array_item|
                        list += array_item.all_keys
                    end
                else
                    list << k
                end
            else
                list << k
            end # end case k

            case v
            when Hash
                list += v.all_keys
            when Array
                if v[0].class == Hash # if the array contains hashes
                    v.each do |array_item|
                        list += array_item.all_keys
                    end
                else
                    # do nothing
                end
            else
                # do nothing
            end # end case v
        end
        list
    end
    
    # Gathers all values in the hash in a flat array, even if it's multi-level    
    # E.g. from {:a => :b, :c => {:d => :e}}, returns [:b, :e]
    def all_values
        list = []
        self.each_pair do |k, v|
            case k
            when Hash
                list += k.all_values
            when Array
                if k[0].class == Hash # if the array contains hashes
                    k.each do |array_item|
                        list += array_item.all_values
                    end
                else
                    # do nothing
                end
            else
                # do nothing
            end # end case k

            case v
            when Hash
                list += v.all_values
            when Array
                if v[0].class == Hash # if the array contains hashes
                    v.each do |array_item|
                        list += array_item.all_values
                    end
                else
                    list << v
                end
            else
                list << v
            end # end case v
        end
        list
    end

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
    
    # A prettier way of printing a hash
    # Want to p each pair, but have each p appear on a new line in STDOUT
    def peach
        self.each_pair { |k, v| puts "#{k.inspect} => #{v.inspect}" }
    end

    # Recursively deletes keys from the hash if the value of that field is nil or empty
    def remove_empty_fields
        self.each_pair do |k, v|
            if self[k].class == Hash
                self[k] = self[k].remove_empty_fields
            else
                self.delete(k) if v.to_s == ""
            end
        end
        self
    end

    # Method to strip from the hash (and all sub-hashes) all keys matching the entries in the supplied array
    # Entries in the array can be strings or other literals, or regexes
    # Directly deletes from self; returns the modified self
    def strip_hash_of_keys(array_of_keys_to_strip)
        self.keys.each do |k|
            strip = false
            array_of_keys_to_strip.each do |i|
                if i.class == Regexp
                    strip = true if k =~ i
                else
                    strip = true if k == i
                end
            end

            if strip
                self.delete(k)
            else
                if self[k].class == Hash
                    self[k] = self[k].strip_hash_of_keys(array_of_keys_to_strip)
                elsif self[k].class == Array
                    self[k].each do |h|
                        h = h.strip_hash_of_keys(array_of_keys_to_strip) if h.class == Hash
                    end
                end
            end
        end
        self
    end

    # Method to fully convert the hash into an array, including all sub-hashes
    # to_a only converts the base level
    def to_a_deep
        self.keys.each do |k|
            if self[k].class == Hash
                self[k] = self[k].to_a_deep
            end
        end
        self.to_a
    end

    # Sorts the hash by its keys. This way, if two versions of the hash (mhich are identical but their k-v pairs are in different order)
    # are both sorted then converted to string (to_s) they will be identical.
    # Assumes that all of the keys in the hash are symbol/string/numeric and are not Hash, Array, etc.
    # Assumes that each key in the hash is unique
    # Sorts deep, not shallow
    # Returns a new hash; does not modify self
    def sort_deep
        new = {}
        keys = self.keys.sort
        keys.each do |main_key|
            self.each_pair do |k, v|
                next unless k == main_key
                if v.class == Hash
                    new[k] = v.sort_deep
                else
                    new[k] = v
                end
            end
        end
        new
    end

    def to_xml
        map do |k, v|
            if v.class == Hash
                text = v.to_xml
            else
                text = v
            end
            "<%s>%s</%s>" % [k, text, k]
        end.join
    end
    
end