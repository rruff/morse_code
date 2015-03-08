require "minitest/autorun"
require "./lib/morse_code/bihash.rb"

class TestBiHash < MiniTest::Test
  
  def setup
    @bihash = BiHash.new
    @bihash[:A] = "abc"
  end
  
  def test_store
    @bihash.store(:C, "def")
    assert_equal("def", @bihash.get_v(:C))
    assert_equal(:C, @bihash.get_k("def"))
  end
  
  def test_get_v
    assert_equal("abc", @bihash.get_v(:A))
  end
  
  def test_get_k
    assert_equal(:A, @bihash.get_k("abc"))
  end
  
  def test_multiple_values_one_key
    @bihash[:B] = "xyz"
    @bihash[:D] = "xyz"
    
    result = @bihash.get_k("xyz")
    assert_respond_to(result, :to_ary, "Result must respond to method to_ary")
    # use eql? because it doesn't care about order of the elements.
    assert([:B, :D].eql?(result))
  end
  
  def test_initialize_with_hash_arg
    bihash2 = BiHash.new({Q: %w(q q q), R: %w(r r r), S: %w(s s s)})
    assert_equal(%w(q q q), bihash2.get_v(:Q))
    assert_equal(:Q, bihash2.get_k(%w(q q q)))
    assert_equal(%w(r r r), bihash2.get_v(:R))
    assert_equal(:R, bihash2.get_k(%w(r r r)))
    assert_equal(%w(s s s), bihash2.get_v(:S))
    assert_equal(:S, bihash2.get_k(%w(s s s)))
  end
end