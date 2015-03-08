require "./lib/morse_code.rb"
require "minitest/autorun"

class TestMorseCode < MiniTest::Test
  
  def test_to_alphanumeric
    result = MorseCode.to_alphanumeric(".... . .-.. .-.. ---//.-- --- .-. .-.. -..")
    assert_equal("Hello World".downcase, result.downcase)
  end
  
  def test_from_alphanumeric
    result = MorseCode.from_alphanumeric("Hello World")
    assert_equal(".... . .-.. .-.. ---//.-- --- .-. .-.. -..", result)
  end
end