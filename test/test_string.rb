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

	def test_snakecase_non_alpha
		a = []
		a << {:raw => "thiNGS", :expected => "thiNGS"}
		a << {:raw => "thiNGS-with_stuff", :expected => "thiNGS_with_stuff"}
		a << {:raw => "thi--_-ngs", :expected => "thi_ngs"}
		a << {:raw => "th2i<>n!!!gs", :expected => "th2i_n_gs"}

		a.each do |x|
			actual = x[:raw].snakecase_non_alpha
			assert_equal(x[:expected], actual, ".snakecase_non_alpha didn't work properly")
		end

	end

	def test_snakecase
		a = []
		a << {:raw => "things", :expected => "things"}
		a << {:raw => "THINGS", :expected => "THINGS"} # should stay the same if all uppercase
		a << {:raw => "REQ_ID", :expected => "REQ_ID"} # should stay the same if all uppercase
		a << {:raw => "REQ_ID2", :expected => "REQ_ID2"}
		a << {:raw => "REQID2", :expected => "reqid_2"}
		a << {:raw => "req_ID", :expected => "req_ID"}
		a << {:raw => "reqID", :expected => "req_id"}
		a << {:raw => "reqId", :expected => "req_id"}
		a << {:raw => "thi_ngs_yes", :expected => "thi_ngs_yes"}
		a << {:raw => "thiNGSYes", :expected => "thi_ngs_yes"}
		a << {:raw => "thiNGS", :expected => "thi_ngs"}
		a << {:raw => "thiNGS-with_stuff", :expected => "thi_ngs_with_stuff"}
		a << {:raw => "thi--_-ngs", :expected => "thi_ngs"}
		a << {:raw => "th2i<>n!!!gs", :expected => "th2i_n_gs"}
		a << {:raw => "THINGS1234STUFF5678", :expected => "things_1234_stuff_5678"}

		a.each do |x|
			actual = x[:raw].snakecase
			assert_equal(x[:expected], actual, "snakecase didn't work properly")
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
			assert_equal(x[:expected], actual, ".camelcase didn't work properly")
		end

	end
end