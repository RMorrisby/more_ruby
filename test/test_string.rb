require "test/unit"
require_relative "../lib/more_ruby"

class TestString < Test::Unit::TestCase

	def test_capitalize_first_letter_only
		input = "someThingELSE"
		expected = "SomeThingELSE"
		actual = input.capitalize_first_letter_only
        assert_equal(expected, actual, ".capitalize_first_letter_only is not behaving correctly")
	end

	def test_capitalize_first_letter_only_single_letter
		input = "s"
		expected = "S"
		actual = input.capitalize_first_letter_only
        assert_equal(expected, actual, ".capitalize_first_letter_only is not behaving correctly")
	end

	def test_capitalize_first_letter_only_empty_string
		input = ""
		expected = ""
		actual = input.capitalize_first_letter_only
        assert_equal(expected, actual, ".capitalize_first_letter_only is not behaving correctly")
	end

	def test_escape_into_regex
		s = "some s\\tring"
		s2 = s.clone
		e = s.escape

		re = Regexp.new(e)

		assert_equal(s, s2, ".escape modified the original string")
		assert_not_equal(e, s, ".escape didn't escape parts of the string")

		assert_equal(re =~ s, 0, ".escape didn't yield an escaped string that could be used to make a Regexp object")
		assert_nil(re =~ e, ".escape yielded an escaped string that matched its Regexp object")
	end

	def test_underbarize
		a = []
		a << {:raw => "thiNGS", :expected => "thiNGS"}
		a << {:raw => "thiNGS-with_stuff", :expected => "thiNGS_with_stuff"}
		a << {:raw => "thi--_-ngs", :expected => "thi_ngs"}
		a << {:raw => "th2i<>n!!!gs", :expected => "th2i_n_gs"}

		a.each do |x|
			actual = x[:raw].underbarize
			assert_equal(actual, x[:expected], ".underbarize didn't work properly")
		end

	end

	def test_underbarize_and_downcase
		a = []
		a << {:raw => "thiNGS", :expected => "things"}
		a << {:raw => "thiNGS-with_stuff", :expected => "things_with_stuff"}
		a << {:raw => "thi--_-ngs", :expected => "thi_ngs"}
		a << {:raw => "th2i<>n!!!gs", :expected => "th2i_n_gs"}

		a.each do |x|
			actual = x[:raw].underbarize_and_downcase
			assert_equal(actual, x[:expected], ".underbarize_and_downcase didn't work properly")
		end

	end

	def test_pascalcase
		a = []
		a << {:raw => "thiNGS", :expected => "Things"}
		a << {:raw => "thiNGS-with_stuff", :expected => "ThingsWithStuff"}
		a << {:raw => "thi--_-ngs", :expected => "ThiNgs"}
		a << {:raw => "th2i<>n!!!gs", :expected => "Th2iNGs"}
		a << {:raw => "a_and_b", :expected => "AAndB"}
		a << {:raw => "A_AND_B", :expected => "AAndB"}
		a << {:raw => "AAndB", :expected => "Aandb"}

		a.each do |x|
			actual = x[:raw].pascalcase
			assert_equal(x[:expected], actual, ".pascalcase didn't work properly")
		end

	end

	def test_camelcase
		a = []
		a << {:raw => "thiNGS", :expected => "things"}
		a << {:raw => "thiNGS-with_stuff", :expected => "thingsWithStuff"}
		a << {:raw => "thi--_-ngs", :expected => "thiNgs"}
		a << {:raw => "th2i<>n!!!gs", :expected => "th2iNGs"}
		a << {:raw => "a_and_b", :expected => "aAndB"}
		a << {:raw => "A_AND_B", :expected => "aAndB"}
		a << {:raw => "AAndB", :expected => "aandb"}

		a.each do |x|
			actual = x[:raw].camelcase
			assert_equal( x[:expected], actual, ".camelcase didn't work properly")
		end

	end
end