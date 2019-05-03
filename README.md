A very simple gem that adds some methods to some Ruby standard classes, e.g. <array>.include_any?, <array>.delete_random, etc.

Simply require the gem ( require "more_ruby" ) and the additional methods will be available.

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