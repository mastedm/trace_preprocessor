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
    
      template.gsub!("COMMON_CODE",         dsl.code)
      template.gsub!("CONVERTER_FUNCTIONS", converter_functions_c_code(dsl))
      template.gsub!("REGEXPS",             regexps(dsl))
    
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
    
    def self.regexps dsl
      result = ""

      dsl.lexemes.each do |name, lexeme|
        if lexeme.regexp
          result += "#{lexeme.regexp.source} parse_#{name}();\n"
        end
      end
      
      result
    end
    
    def self.output_token_code dsl
<<-CODE
void output_token(const char* name, const char* source, long value, int value_kind) {
    #{dsl.output_token_code}
}  
CODE
    end
    
    def self.parse_lexeme_code(name, lexeme)
<<-CODE
long converter_#{name}() {
    #{lexeme.converter[:c]}
}

void parse_#{name}() {
    output_token("#{name}", yytext, converter_#{name}(), #{lexeme.value_kind == :exact ? 1 : 0});
}
CODE
    end
    
  end # CodeGenerator
end # TracePreprocessor