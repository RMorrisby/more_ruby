# Script to help produce summary documentation for more_ruby

def diff_out(a1, a2)
	diff = a1 - a2
	return "" if diff.empty?
	":" + diff.join(", :")
end

classes = [String, Array, Numeric, Integer, Float, Fixnum, FalseClass, NilClass, TrueClass, Time, Enumerable, File, Hash]
classes.sort_by! { |z| z.to_s }

out = {}
classes.each { |z| out[z.to_s] = {} }

classes.each do |z|
	out[z.to_s][:before_instance] = z.instance_methods.sort
	out[z.to_s][:before_singleton] = z.singleton_methods.sort
end

require_relative 'lib/more_ruby.rb'

classes.each do |z|
	out[z.to_s][:after_instance] = z.instance_methods.sort
	out[z.to_s][:after_singleton] = z.singleton_methods.sort
end

puts "# New instance methods #\n"

classes.each do |z|
	diff = diff_out(out[z.to_s][:after_instance], out[z.to_s][:before_instance])	
	puts "\n## #{z.to_s}\n" + diff unless diff.empty?
end

puts ""
puts "# New singleton methods #\n"

classes.each do |z|
	diff = diff_out(out[z.to_s][:after_singleton], out[z.to_s][:before_singleton])	
	puts "\n## #{z.to_s}\n" + diff unless diff.empty?
end

exit

s1 = String.instance_methods.sort
a1 = Array.instance_methods.sort
n1 = Numeric.instance_methods.sort
i1 = Integer.instance_methods.sort
t1 = Time.instance_methods.sort
true1 = TrueClass.instance_methods.sort
false1 = FalseClass.instance_methods.sort
nil1 = NilClass.instance_methods.sort

true1s = TrueClass.singleton_methods.sort
false1s = FalseClass.singleton_methods.sort

require_relative 'lib/more_ruby.rb'

s2 = String.instance_methods.sort
a2 = Array.instance_methods.sort
n2 = Numeric.instance_methods.sort
i2 = Integer.instance_methods.sort
t2 = Time.instance_methods.sort
true2 = TrueClass.instance_methods.sort
false2 = FalseClass.instance_methods.sort
nil2 = NilClass.instance_methods.sort

true2s = TrueClass.singleton_methods.sort
false2s = FalseClass.singleton_methods.sort

puts "## New instance methods ##\n"
puts "\n# String\n" + diff_out(s2, s1) unless s2.empty?
puts "\n# Array\n" + diff_out(a2, a1) unless a2.empty?
puts "\n# Numeric\n" + diff_out(n2, n1) unless h2.empty?
puts "\n# Integer\n" + diff_out(i2, i1) unless n2.empty?
puts "\n# Time\n" + diff_out(t2, t1) unless true2.empty?
puts "\n# TrueClass\n" + diff_out(true2, true1) unless true2.empty?
puts "\n# FalseClass\n" + diff_out(false2, false1) unless true2.empty?
puts "\n# NilClass\n" + diff_out(nil2, nil1) unless true2.empty?

puts "## New instance methods ##\n"