require "minitest/autorun"
require "./lib/morse_code/lookup.rb"

class TestExtHash < MiniTest::Test
  
  def test_invert_with_mods
    h = {A: %w(a b c), B: %w(d e f), C: %w(g h i)}
    h.extend(MorseCode::ExtHash)

    h = h.invert_with_mods do |k, v|
      [k.to_s, v.join.to_sym]
    end

    assert_equal("A", h[:abc])
    assert_equal("B", h[:def])
    assert_equal("C", h[:ghi])
  end
end