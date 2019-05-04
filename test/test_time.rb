require "test/unit"
require_relative "../lib/more_ruby"

class TestArray < Test::Unit::TestCase

	def test_remove_subseconds
		t = Time.now
		t2 = t.remove_subseconds

		assert_not_equal(t, t2, "remove_subseconds didn't work")
		assert_equal(t2.subsec.to_s, "0", "remove_subseconds didn't work")
		assert_equal(t2.usec.to_s, "0", "remove_subseconds didn't work")

	end

end