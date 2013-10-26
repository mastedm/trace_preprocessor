require 'trace_preprocessor'

include TracePreprocessor

describe DSL do
  it "smoke test for initialize DSL object" do
    dsl = DSL.new
  end
  
  it "init with simple form of define_lexeme (default values)" do
    dsl = DSL.new
    
    lexeme = dsl.define_lexeme :id, :regexp => /[0-9]+/
    lexeme.name.should eq :id
    lexeme.value_kind.should eq :hash   
  end
  
  it "converter in C" do
    dsl = DSL.new
    
    dsl.init do
      define_lexeme :id, 
        :regexp     => /[0-9]+/,
        :converter  => "return atol(str);",
        :priority   => 1,
        :value_kind => :exact
    end
    
    dsl.lexemes.length.should eq 1
    
    lexeme = dsl.lexemes[:id]
    lexeme.regexp.should eq /[0-9]+/    
    lexeme.value_kind.should eq :exact
    lexeme.converter.length.should eq 1
    lexeme.converter[:c].should_not be_nil
    lexeme.converter[:ruby].should be_nil
  end
  
  it "converter in Ruby" do
    dsl = DSL.new
    
    dsl.init do
      define_lexeme :id, 
        :regexp     => /[0-9]+/,
        :converter  => lambda { |str| str.to_i },
        :value_kind => :hash
    end
    
    dsl.lexemes[:id].converter[:ruby].should_not be_nil
  end
  
  it "common code" do
    dsl = DSL.new
    
    dsl.init do
      common_code <<-CODE
        #include <stdio.h>
        #include <stdlib.h>
      CODE
    end    
  end
end