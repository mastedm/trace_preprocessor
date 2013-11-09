%w(
  lexeme
).each do |file| 
  require File.join(File.dirname(__FILE__), file) 
end

require 'fileutils'

module TracePreprocessor
  class DSL
    def initialize
      @lexemes = {}
      @code = ""
      
      workspace "~/.trace_preprocessor"
    end
    
    def init &block
      instance_eval &block
    end
    
    def define_lexeme name, options
      lexeme = @lexemes[name] || Lexeme.new(name, options)
      
      converter = options[:converter]
      converter_language = :c
      converter_language = :ruby if converter.instance_of? Proc
      lexeme.converter[converter_language] = converter
      
      @lexemes[lexeme.name] = lexeme
      
      lexeme
    end
    
    def use_default_lexemes
      default_lexemes_file_name = File.join(File.dirname(__FILE__), "default_lexemes.rb")
      eval open(default_lexemes_file_name, "r") { |fd| fd.read }
    end
    
    def common_code code
      @code += code
    end
    
    def output_token code
      @output_token_code = code
    end
    
    def workspace path
      @workspace_path = File.expand_path path
      
      if not File.exist? @workspace_path
        FileUtils.mkdir_p @workspace_path
      end
    end
    
    attr_accessor :lexemes
    attr_accessor :code, :output_token_code
    attr_accessor :workspace_path
  end
end