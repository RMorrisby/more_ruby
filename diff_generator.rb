# Script to help produce summary documentation for more-ruby

def diff_out(a1, a2)
	":" + (a1 - a2).join(", :")
end

s1 = String.instance_methods.sort
a1 = Array.instance_methods.sort
n1 = Numeric.instance_methods.sort
i1 = Integer.instance_methods.sort
t1 = Time.instance_methods.sort
true1 = TrueClass.instance_methods.sort
false1 = FalseClass.instance_methods.sort
nil1 = NilClass.instance_methods.sort

require_relative 'lib/more-ruby.rb'

s2 = String.instance_methods.sort
a2 = Array.instance_methods.sort
n2 = Numeric.instance_methods.sort
i2 = Integer.instance_methods.sort
t2 = Time.instance_methods.sort
true2 = TrueClass.instance_methods.sort
false2 = FalseClass.instance_methods.sort
nil2 = NilClass.instance_methods.sort

puts "## New instance methods ##\n"
puts "\n# String\n" + diff_out(s2, s1)
puts "\n# Array\n" + diff_out(a2, a1)
puts "\n# Numeric\n" + diff_out(n2, n1)
puts "\n# Integer\n" + diff_out(i2, i1)
puts "\n# Time\n" + diff_out(t2, t1)
puts "\n# TrueClass\n" + diff_out(true2, true1)
puts "\n# FalseClass\n" + diff_out(false2, false1)
puts "\n# NilClass\n" + diff_out(nil2, nil1)

