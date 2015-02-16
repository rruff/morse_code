require "./lib/morse_code.rb"
require "minitest/autorun"

class TestMorseCode < MiniTest::Test
  
  def test_to_alphanumeric
    assert_equal("Hello World", MorseCode.to_alphanumeric(".... . .-.. .-.. ---//.-- --- .-. .-.. -.."))
  end
  
end