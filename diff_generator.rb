# Script to help produce summary documentation for more_ruby

def diff_out(a1, a2)
	diff = a1 - a2
	return "" if diff.empty?
	":" + diff.join(", :")
end

classes = [String, Array, Numeric, Integer, Float, Fixnum, FalseClass, NilClass, TrueClass, Time, Enumerable, File, Hash, Object]
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

puts "Press any key to close..."
gets