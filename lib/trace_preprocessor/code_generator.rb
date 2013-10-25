module TracePreprocessor
  module CodeGenerator
    
    def self.generate_lex dsl
      template = 
<<-LEX
%{
COMMON_CODE

CONVERTER_FUNCTIONS  
%}    

%option nounput

%%

REGEXPS

%%
LEX
    
      template.gsub!("COMMON_CODE", dsl.code)
      template.gsub!("CONVERTER_FUNCTIONS", dsl._converter_functions_c_code)
    
      template
    end
    
    def self.converter_functions_c_code dsl
      result = output_token_code dsl

      dsl.lexemes.each do |name, lexeme|
        if lexeme.converter[:c]
          result += parse_lexeme_code(name, lexeme)
        end
      end

      result      
    end
    
    def output_token_code dsl
<<-CODE
void output_token(const char* name, const char* source, long value) {
    #{dsl.output_token_code}
}  
CODE
    end
    
    def parse_lexeme_code(name, lexeme)
<<-CODE
long converter_#{name}() {
    #{lexeme.converter[:c]}
}

void parse_#{name}() {
    output_token("#{name}", yytext, converter_#{name}());
}
CODE
    end
    
  end # CodeGenerator
end # TracePreprocessor