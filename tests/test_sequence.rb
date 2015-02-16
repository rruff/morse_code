require "minitest/autorun"
require "./lib/morse_code/sequence.rb"

class TestSequence < MiniTest::Test
  def test_init_with_string
    b = MorseCode::Sequence.new("-...")
    assert_equal(%w(- . . .), b.signals)
  end
  
  def test_init_with_array
    p = MorseCode::Sequence.new(%w(. - - .))
    assert_equal(%w(. - - .), p.signals)
  end
  
  def test_raise_invalid_signal
    err = assert_raises(MorseCode::InvalidSignalError) do
      seq = MorseCode::Sequence.new(%w(- . . x))
    end
    
    assert_equal(%w(- . . x), err.signal)
  end
end