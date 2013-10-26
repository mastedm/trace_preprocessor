module TracePreprocessor
  class Preprocessor
    attr_accessor :language
    attr_accessor :preprocessor_file_name
    
    def initialize language, preprocessor_file_name
      @language = language
      @preprocessor_file_name = preprocessor_file_name
    end
    
    def run input_file_name, output_file_name
      if @language == :c
        `#{preprocessor_file_name} < #{input_file_name} > #{output_file_name}`
      end
    end
  end
end