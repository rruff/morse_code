class BiHash
  def initialize(hsh = {})
    @k_to_v = {}.merge(hsh)
    # Since a value may be mapped by multiple keys, 
    # use an array for the values-to-keys lookup.
    @v_to_k = Hash.new { |h, k| h[k] = [] }
    hsh.each { |k, v| @v_to_k[v].push(k) }
  end
  
  def store(key, value)
    @k_to_v[key] = value
    @v_to_k[value].push(key)
  end
  
  alias :"[]=" :store
  
  def get_v(key)
    @k_to_v[key]
  end
  
  def get_k(val)
    k = @v_to_k[val]
    # When returning the whole array, return a dup
    # to prevent external modification of the original.
    k.length == 1 ? k.first : k.dup
  end
  
  def length
    @k_to_v.length
  end
  
  def has_key?(key)
    @k_to_v.has_key?
  end
  
  def has_value?(value)
    @v_to_k.has_key?
  end
end