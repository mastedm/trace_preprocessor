module TracePreprocessor
  class Lexeme
    def initialize name, options
      @name = name
      @converter = {}      
      
      @regexp     = options[:regexp]
      @priority   = options[:priority]
      @value_kind = options[:value_kind] || :hash
    end
    
    attr_accessor :name, :regexp, :converter, :value_kind, :priority
  end
end