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
  
  def test_init_with_second_arg
    r = MorseCode::Sequence.new(%w(. - .), 'r')
    assert_equal('r', r.char)
  end
  
  def test_raise_invalid_signal
    err = assert_raises(MorseCode::InvalidSignalError) do
      seq = MorseCode::Sequence.new(%w(- . . x))
    end
    
    assert_equal(%w(- . . x), err.signal)
  end
  
  def test_to_sym
    p = MorseCode::Sequence.new(%w(. - - .))
    assert_equal(:".--.", p.to_sym)
  end
  
  def test_to_alphanumeric
    one = MorseCode::Sequence.new(".----")
    assert_equal("1", one.to_alphanumeric)
  end
end