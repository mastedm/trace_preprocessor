require 'trace_preprocessor'

include TracePreprocessor

describe Preprocessor do
  it "priority test" do
    
    config = TracePreprocessor.init do
      output_token "printf(\"%ld\", value);"
      workspace "~/.trace_preprocessor"

      define_lexeme :id1,
          :regexp     => /[0-9]+/,
          :converter  => "return atol(yytext);",
          :value_kind => :exact,
          :priority   => 2          
      
      define_lexeme :id2,
          :regexp     => /[0-9]+/,
          :converter  => "return -atol(yytext);",
          :value_kind => :exact,
          :priority   => 1
          
          
      define_lexeme :id3,
          :regexp     => /[0-9]+/,
          :converter  => "return atol(yytext);",
          :value_kind => :exact,
          :priority   => 3 

    end
    
    preprocessor = TracePreprocessor.generate(config, :c)

    input  = config.workspace_path + "/preprocessor_spec-in.txt"
    output = config.workspace_path + "/preprocessor_spec-out.txt"
    
    puts "input = #{input}"
    puts "output = #{output}"
    
    open(input, "w") { |fd| fd.write "123456" }
    
    preprocessor.run(input, output)
    
    result = open(output, "r") { |fd| fd.read }
    
    result.should eq "-123456"
    
  end
end