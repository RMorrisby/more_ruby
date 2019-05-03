require "test/unit"
require "test/unit"
require_relative "../lib/more-ruby"

class TestArray < Test::Unit::TestCase

	def test_format_with_thousands_delimiter
		a = []
		a << {:raw => 234, :expected => "234"}
		a << {:raw => 2326759, :expected => "2,326,759"}
		a << {:raw => 2326759, :expected => "2.326.759", :delimiter => "."}
		a << {:raw => 2326759, :expected => "2.-.326.-.759", :delimiter => ".-."}
		a << {:raw => 2326759.123456, :expected => "2,326,759.123456"}
		a << {:raw => -2326759.123456, :expected => "-2,326,759.123456"}
		a << {:raw => 0.23456, :expected => "0.23456"}

		a.each do |x|
			if x[:delimiter]
				processed = x[:raw].format_with_thousands_delimiter(x[:delimiter])
			else
				processed = x[:raw].format_with_thousands_delimiter
			end
			assert_equal(x[:expected], processed, ".format_with_thousands_delimiter did not produce the expected result; delimiter? #{x[:delimiter] != nil ? x[:delimiter] : "<none>"} with #{x[:raw]}, expected #{x[:expected]} but received #{processed}")
		end
	end

end