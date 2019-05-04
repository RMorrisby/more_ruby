A very simple gem that adds some methods to some Ruby standard classes, e.g. <array>.include_any?, <array>.delete_random, etc.

Simply require the gem ( require "more_ruby" ) and the additional methods will be available.

## New instance methods ##

# Array
:all_instance_of?, :all_kind_of?, :av, :delete_random, :include_any?, :insert_flat, :mean, :modulo_fetch, :peach, :random, :random_index, :random_insert, :random_move, :stringify_all_values_deep, :sum, :wrap_fetch

# Fixnum
:digit_count, :format_with_thousands_delimiter, :num_to_letter, :signif

# Float
:format_with_thousands_delimiter, :signif

# Hash
:all_keys, :all_values, :delete_random, :peach, :random_key, :random_pair, :random_value, :remove_empty_fields, :sort_deep, :stringify_all_values_deep, :strip_hash_of_keys, :to_a_deep, :to_xml

# Integer
:digit_count, :format_with_thousands_delimiter, :signif

# NilClass
:empty?

# Numeric
:format_with_thousands_delimiter

# String
:append, :camelcase, :camelcase_to_snakecase, :capitalize_all, :capitalize_first_letter_only, :escape, :escape_whitespace, :extract_values_from_xml_string, :formatted_number, :index_of_last_capital, :invert_case, :is_hex?, :is_integer?, :join, :pascalcase, :prefix_lines, :random_case, :snakecase, :snakecase_and_downcase, :to_bool, :unindent

# Time
:is_after?, :is_before?, :is_within?, :remove_subseconds

## New singleton methods ##

# FalseClass
:maybe?, :random

# File
:basename_no_ext

# TrueClass
:maybe?, :random
