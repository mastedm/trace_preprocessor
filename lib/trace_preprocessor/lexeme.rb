module TracePreprocessor
  class Lexeme
    def initialize name
      @name = name
      @converter = {}      
    end
    
    attr_accessor :name, :regexp, :converter, :value_kind, :priority
  end
end