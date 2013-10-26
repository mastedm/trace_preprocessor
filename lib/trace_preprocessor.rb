%w(
  version
  dsl
  code_generator
  preprocessor
).each do |file| 
  require File.join(File.dirname(__FILE__), 'trace_preprocessor', file) 
end

include TracePreprocessor

module TracePreprocessor

  def self.init &block
    dsl = DSL.new
    dsl.init &block
    dsl
  end
  
  def self.generate config, language
    if language == :c
      lex = CodeGenerator.generate_lex config
      
      open(config.workspace_path + "/preprocessor.l", "w") { |fd| fd.write lex }
      
      `cd #{config.workspace_path}; flex -o preprocessor.c preprocessor.l; gcc -o preprocessor -ll preprocessor.c`
      
      Preprocessor.new(:c, config.workspace_path + "/preprocessor")
    else
    end    
  end

end
