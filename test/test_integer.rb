require "test/unit"
require_relative "../lib/more-ruby"

class TestArray < Test::Unit::TestCase

	def test_signif_digits
		a = []
		a << {:raw => 2326759, :digits => 2, :pro => 2300000}
		a << {:raw => 2326759, :digits => 3, :pro => 2330000}
		a << {:raw => 2326759, :digits => 4, :pro => 2327000}
		a << {:raw => 2326759, :digits => 5, :pro => 2326800}
		a << {:raw => 2326759, :digits => 6, :pro => 2326760}
		a << {:raw => 2326759, :digits => 7, :pro => 2326759}
		a << {:raw => 2326759, :digits => 8, :pro => 2326759}
		a << {:raw => 23, :digits => 3, :pro => 23}
		a << {:raw => 23, :digits => 2, :pro => 23}
		a << {:raw => 23, :digits => 1, :pro => 20}    	
		a << {:raw => 23, :digits => 0, :pro => 0}
		a << {:raw => 10.546, :digits => 0, :pro => 0}
		a << {:raw => 10.546, :digits => 1, :pro => 10.0}
		a << {:raw => 10.546, :digits => 2, :pro => 10.0}
		a << {:raw => 10.546, :digits => 3, :pro => 10.5}
		a << {:raw => 10.546, :digits => 4, :pro => 10.55}
		a << {:raw => 10.546, :digits => 5, :pro => 10.546}
		a << {:raw => 10.546, :digits => 6, :pro => 10.546}
		a << {:raw => 0.766, :digits => 2, :pro => 0.77}
		a << {:raw => 0.00000766, :digits => 4, :pro => 0.00000766}
		a << {:raw => 0.00000766, :digits => 3, :pro => 0.00000766}
		a << {:raw => 0.00000766, :digits => 2, :pro => 0.0000077}
		a << {:raw => 0.00000766, :digits => 1, :pro => 0.000008}
		a << {:raw => 0.00000766, :digits => 0, :pro => 0}
		a << {:raw => 0.0, :digits => 4, :pro => 0.0}
		a << {:raw => 0.0, :digits => 1, :pro => 0.0}
		a << {:raw => 0.0, :digits => 0, :pro => 0.0}
		a << {:raw => 1.00000766, :digits => 8, :pro => 1.0000077}
		a << {:raw => 1.00000766, :digits => 3, :pro => 1.0}
		a << {:raw => 1.00000766, :digits => 2, :pro => 1.0}
		a << {:raw => 1.00000766, :digits => 1, :pro => 1}
		a << {:raw => 1.00000766, :digits => 0, :pro => 0}
		a << {:raw => -23, :digits => 3, :pro => -23}
		a << {:raw => -0.0, :digits => 1, :pro => -0.0}
		a << {:raw => -2326759, :digits => 5, :pro => -2326800}
		a << {:raw => -1.00000766, :digits => 8, :pro => -1.0000077}

		a.each do |x|
			processed = x[:raw].signif(x[:digits])
			assert_equal(x[:pro], processed, ".signif did not produce the expected result; for digit-count of #{x[:digits]} with #{x[:raw]}, expected #{x[:pro]} but received #{processed}")
		end
	end

end