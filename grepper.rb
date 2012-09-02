#!/usr/bin/env ruby

$LOAD_PATH << './lib'

require 'trollop'
require 'Grepper'

options = Trollop::options do
	opt :ignore_case, "Case-insensitive matching"
	opt :invert_match, "Inverted matching", :short => '-v'
	opt :line, "Display line number", :short => '-n'
	opt :filename, "Display file name"
end

grepper = Grepper::Grepper.new(
	:pattern => ARGV.shift,
	:is_case_sensitive => ! options[:ignore_case],
	:is_inverted => options[:invert_match],
	:show_file_name => options[:filename],
	:show_line_number => options[:line],
);

grepper.match(ARGF)
