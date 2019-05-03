Gem::Specification.new do |s|
  s.name        = 'more-ruby'
  s.version     = '0.1.5'
  s.licenses    = ['MIT']
  s.summary     = "Adds some extra methods to some Ruby standard classes"
  s.authors     = ["Richard Morrisby"]
  s.email       = 'rmorrisby@gmail.com'
  s.files       = ["lib/more-ruby.rb"]
  s.homepage    = 'https://rubygems.org/gems/more-ruby'
  s.required_ruby_version = '>=1.9'
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENCE.txt README.md)
  s.test_files = Dir["test/test*.rb"]
  s.has_rdoc = true
  s.description = <<-DESC
A very simple gem that adds some methods to some Ruby standard classes, e.g. <array>.include_any?, <array>.delete_random, etc.

Simply require the gem ( require "more-ruby" ) and the additional methods will be available.

## New instance methods ##

# String
:append, :camelcase, :capitalize_first_letter_only, :escape, :join, :pascalcase, :random_case, :underbarize, :underbarize_and_downcase

# Array
:all_instance_of?, :all_kind_of?, :av, :delete_random, :include_any?, :insert_flat, :mean, :modulo_fetch, :random, :sum, :wrap_fetch

# Numeric
:format_with_thousands_delimiter

# Integer
:digit_count, :format_with_thousands_delimiter, :signif

# Time
:remove_subseconds

# TrueClass
:maybe?, :random

# FalseClass
:maybe?, :random

# NilClass
:empty?

  DESC
end