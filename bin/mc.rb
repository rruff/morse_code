#! /usr/bin/env ruby

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'morse_code'

puts "Hello World => #{MorseCode.from_alphanumeric('Hello World')}"