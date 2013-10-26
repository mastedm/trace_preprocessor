# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trace_preprocessor/version'

Gem::Specification.new do |spec|
  spec.name          = "trace_preprocessor"
  spec.version       = TracePreprocessor::VERSION
  spec.authors       = ["Sergey"]
  spec.email         = ["mastedm@gmail.com"]
  spec.description   = %q{Log data preprocessor}
  spec.summary       = %q{Log data preprocessor}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
