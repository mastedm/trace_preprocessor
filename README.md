# TracePreprocessor

Simple trace preprocess based on lexical analyzer

## Installation

Add this line to your application's Gemfile:

    gem 'trace_preprocessor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trace_preprocessor

## Usage

#!/usr/bin/env ruby

	require 'trace_preprocessor'

	# Configuration
	config = TracePreprocessor.init do
	  define_lexeme :id,
	    :regexp     => /[0-9]+/,
	    :converter  => "return atol(yytext);",
	    :value_kind => :exact,
	    :priority   => 1

	  output_token "printf(\"{TOKEN;%s;%s;%ld;%d}\", name, source, value, value_kind);"

	  workspace "~/.trace_preprocessor"
	end

	# Generate preprocessor
	preprocessor = TracePreprocessor.generate(config, :c)

	# Preprocessor run
	preprocessor.run("input.txt", "output.txt")


