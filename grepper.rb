#!/usr/bin/env ruby

$LOAD_PATH << './lib'

require 'trollop'
require 'Grepper'

options = Trollop::options do
	opt :ignore_case, "Case-insensitive matching"
	opt :invert_match, "Inverted matching", :short => '-v'
end

grepper = Grepper::Grepper.new;
grepper.is_case_sensitive = ! options[:ignore_case]
grepper.is_inverted = options[:invert_match]
grepper.pattern = ARGV.shift;
grepper.match(ARGF)
