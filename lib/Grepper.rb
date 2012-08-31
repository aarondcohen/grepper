module Grepper

class Grepper
	attr_accessor :is_case_sensitive, :is_inverted, :pattern

	def initialize(params = {})
		@is_case_sensitive = params.member?(:is_case_sensitive) ? !! params[:is_case_sensitive] : true
		@is_inverted = !! params[:is_inverted]
		@pattern = params[:pattern]
	end

	def match(stream)
		compiled_pattern = Regexp.new(self.pattern, self.is_case_sensitive ? nil : Regexp::IGNORECASE)
		stream.each_line { |line|
			puts line if self.is_inverted ^ (line =~ compiled_pattern)
		}
	end

end #End class Grepper

end #End module Grepper
