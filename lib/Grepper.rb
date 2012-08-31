module Grepper

class Grepper
	attr_accessor :is_case_sensitive, :is_inverted, :pattern, :show_file_name, :show_line_number

	def initialize(params = {})
		@is_case_sensitive = params.member?(:is_case_sensitive) ? !! params.key(:is_case_sensitive) : true
		@is_inverted = !! params.key(:is_inverted)
		@pattern = params.key(:pattern)
		@show_file_name = !! params.key(:show_file_name)
		@show_line_number = !! params.key(:show_line_number)
	end

	def match(stream)
		compiled_pattern = Regexp.new(self.pattern, self.is_case_sensitive ? nil : Regexp::IGNORECASE)
		output_format = [
			self.show_file_name ? "[#{stream.filename}]" : nil,
			self.show_line_number ? "[%{line_number}]" : nil,
			'%{line}',
		].compact.join(':');

		stream.each_line { |line|
			if self.is_inverted ^ (line =~ compiled_pattern)
				puts sprintf output_format, {:line_number => stream.lineno, :line => line}
			end
		}
	end

end #End class Grepper

end #End module Grepper
