require "test/unit"
require_relative "../lib/more_ruby"

class TestArray < Test::Unit::TestCase

    def test_random
        a = (1 .. 20).to_a
        randoms = []
        count = 20
        count.times do
            randoms << a.random
        end
        
        assert_equal(count, randoms.size)
        
        randoms.compact!
        assert_equal(count, randoms.size, ".random returned nils")
        
        randoms.uniq!
        assert_empty(randoms - a, ".random returned values not in the original array")
        
        # Extremely unlikely to happen, but rand may roll in order for every call in this test
        assert_not_equal(a, randoms, ".random did not return values in a random order")
    end
    
    def test_delete_random_size
        orig_size = 20
        a = (1 .. orig_size).to_a
        count = 10
        count.times do |i|
            deleted = a.delete_random

            assert_not_equal(orig_size, a.size, ".delete_random is not deleting from self")
            
            assert_equal(orig_size - (i + 1), a.size, ".delete_random is deleting too many from self")
            
            # TODO would be nice to test randomness, but that's pretty difficult    
        end
    end
    
    def test_delete_random_return
        b = [3, 3, 3]
        deleted = b.delete_random
        
        assert_not_empty(b, ".delete_random is deleting by object, not by index")
        assert_not_equal(b.uniq, b, ".delete_random is deleting by object, not by index")
        assert_equal(deleted, b.random, ".delete_random is not returning the deleted item")
        assert_not_nil(deleted, ".delete_random is not returning the deleted item")
        
    end
    
    def test_mean
        a = (1 .. 6).to_a # mean is 3.5
        expected = 3.5
        mean = a.mean
        assert_kind_of(Float, mean, ".mean did not return a Float")
        assert_equal(mean, expected, ".mean is not returning the correct mean")
    end
    
    def test_av
        a = (1 .. 6).to_a # mean is 3.5
        expected = 3.5
        mean = a.av
        assert_kind_of(Float, mean, ".av did not return a Float")
        assert_equal(mean, expected, ".av is not returning the correct mean")
    end

    def test_mean_mixed_numerics
        a = [1, 2.0, -6789, 432.123456, 0, 0x04B, 01000, 0b1000]
        expected = -719.859568
        mean = a.mean
        assert_kind_of(Float, mean, ".mean did not return a Float")
        assert_equal(mean, expected, ".mean is not returning the correct mean")
    end

    def test_non_numeric_mean
        assert_exception_message_correct_non_numeric_mean ["a", "b", "c"]
        assert_exception_message_correct_non_numeric_mean ["1", "2", "c"]
        assert_exception_message_correct_non_numeric_mean [1, 2, "c", 4]
        assert_exception_message_correct_non_numeric_mean [1, 2, "3", 4]
        assert_exception_message_correct_non_numeric_mean [1, nil, 3, 4]
        assert_exception_message_correct_non_numeric_mean [1, false, true, 4]
    end

    def assert_exception_message_correct_non_numeric_mean(array) 
        exception = assert_raise(TypeError) {array.mean}
        assert_equal("Cannot determine the mean of an array that contains non-Numeric objects.", exception.message) 
    end

    def test_sum
        a = (1 .. 6).to_a
        expected = 21
        sum = a.sum
        assert_kind_of(Integer, sum, ".sum did not return a Integer")
        assert_equal(sum, expected, ".sum is not returning the correct sum")
    end

    def test_sum_floats
        a = (1 .. 6).to_a
        a << 4.32
        expected = 25.32
        sum = a.sum
        assert_kind_of(Float, sum, ".sum did not return a Float")
        assert_equal(sum, expected, ".sum is not returning the correct sum")
    end

    def test_sum_non_numeric
        a = (1 .. 6).to_a
        a << "4.32"
        exception = assert_raise(TypeError) {a.sum}
        assert_equal("Array contained non-numeric non-nil elements; cannot sum contents.", exception.message) 
    end

    def test_sum_with_nil
        a = (1 .. 6).to_a
        a << nil
        a << 4.32
        a << -26
        expected = -0.68
        sum = a.sum.signif(8) # need to work around floating-point precision issues
        assert_kind_of(Float, sum, ".sum did not return a Float")
        assert_equal(sum, expected, ".sum is not returning the correct sum")
    end

    def test_insert_flat
        a = [1, 2, 3]
        b = [4, 5]
        expected = [4, 5, 1, 2, 3]
        a.insert_flat(0, b)
        assert_equal(expected, a, ".insert_flat failed")
    end

    def test_insert_flat_preserving_subarrays
        a = [1, [2.1, 2.2], 3]
        b = [4, 5]
        expected = [1, [2.1, 2.2], 4, 5, 3]
        a.insert_flat(-2, b)
        assert_equal(expected.size, a.size, ".insert_flat failed to preserve preexisting subarray")
        assert_equal(expected, a, ".insert_flat failed")
    end

    def test_all_kind_of
        a = ["A string", :smybol, false, 1]
        assert_false(a.all_kind_of?(String), ".all_kind_of? returned true when there were distinctly different types in the array")
        assert(a.all_kind_of?(Object), ".all_kind_of? returned true when there were distinctly different types in the array")

        b = (1 .. 4).to_a
        assert(b.all_kind_of?(Numeric), ".all_kind_of? returned false when the array's contents were all subclasses of the questioned class")
        assert(b.all_kind_of?(Integer), ".all_kind_of? returned false when the array's contents were all subclasses of the questioned class")
        assert(b.all_kind_of?(Fixnum), ".all_kind_of? returned false when the array's contents were all instances of the questioned class")

        b.insert(2, 2.0)
        assert(b.all_kind_of?(Numeric), ".all_kind_of? returned false when the array's contents were all subclasses of the questioned class")
        assert_false(b.all_kind_of?(Integer), ".all_kind_of? returned true when there were distinctly different types in the array")
        assert_false(b.all_kind_of?(Fixnum), ".all_kind_of? returned true when there were distinctly different types in the array")
    end


    def test_all_instance_of
        a = ["A string", :smybol, false, 1]
        assert_false(a.all_instance_of?(String), ".all_instance_of? returned true when there were distinctly different types in the array")
        assert_false(a.all_instance_of?(Object), ".all_instance_of? returned true when there were distinctly different types in the array")

        b = (1 .. 4).to_a
        assert_false(b.all_instance_of?(Numeric), ".all_instance_of? returned true when the array's contents were all subclasses of the questioned class")
        assert_false(b.all_instance_of?(Integer), ".all_instance_of? returned true when the array's contents were all subclasses of the questioned class")
        assert(b.all_instance_of?(Fixnum), ".all_instance_of? returned false when the array's contents were all instances of the questioned class")

        b.insert(2, 2.0)
        assert_false(b.all_instance_of?(Numeric), ".all_instance_of? returned true when the array's contents were all subclasses of the questioned class")        
    end

    def test_wrap_fetch
        a = [:a, :b, :c, :d]
        assert_equal(:a, a.wrap_fetch(0), "wrap_fetch failed")
        assert_equal(:d, a.wrap_fetch(3), "wrap_fetch failed")
        assert_equal(:d, a.wrap_fetch(-1), "wrap_fetch failed")
        assert_equal(:a, a.wrap_fetch(-4), "wrap_fetch failed")
        assert_equal(:a, a.wrap_fetch(4), "wrap_fetch failed")
        assert_equal(:b, a.wrap_fetch(5), "wrap_fetch failed")
        assert_equal(:c, a.wrap_fetch(494), "wrap_fetch failed")
        assert_equal(:c, a.wrap_fetch(-494), "wrap_fetch failed")        

        b = []
        assert_nil(b.wrap_fetch(0), "wrap_fetch failed")
    end

    def test_modulo_fetch
        a = [:a, :b, :c, :d]
        assert_equal(:b, a.modulo_fetch(5), "modulo_fetch failed")
    end

end