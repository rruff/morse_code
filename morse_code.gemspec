# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "morse_code"
  spec.version       = '1.0'
  spec.authors       = ["Rob Ruff"]
  spec.email         = ["robruff@gmail.com"]
  spec.summary       = %q{Morse Code translator}
  spec.description   = %{This module provides services for translating text to and from Morse Code.}
  spec.homepage      = "http://www.robruff.net"
  spec.license       = "Apache"
  
  spec.files         = ['lib/morse_code.rb', 'lib/morse_code/lookup.rb']
  spec.executables   = ['bin/NAME']
  spec.test_files    = ['tests/test_morse_code.rb']
  spec.require_paths = ["lib"]
end