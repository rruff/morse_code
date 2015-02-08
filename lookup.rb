module MorseCode
  # A lookup table mapping Morse Code sequences to corresponding
  # alphanueric characters and vice versa.
  class Lookup
    class << self
      attr_reader :char_to_seq, :seq_to_char
    end
    
    def self.create_seq_map(char_map)
      seq_map = Hash.new
      char_map.each { |k, v| seq_map[v.join.to_sym] = k.to_s.freeze }
      seq_map
    end
    private_class_method :create_seq_map
    
    @char_to_seq = {
      :A => %w(. -).freeze,
      :B => %w(- . . .).freeze,
      :C => %w(- . - .).freeze,
      :D => %w(- . .).freeze,
      :E => %w(.).freeze,
      :F => %w(. . - .).freeze,
      :G => %w(- - .).freeze,
      :H => %w(. . . .).freeze,
      :I => %w(. .).freeze,
      :J => %w(. - - -).freeze,
      :K => %w(- . -).freeze,
      :L => %w(. - . .).freeze,
      :M => %w(- -).freeze,
      :N => %w(- .).freeze,
      :O => %w(- - -).freeze,
      :P => %w(. - - .).freeze,
      :Q => %w(- - . -).freeze,
      :R => %w(. - .).freeze,
      :S => %w(. . .).freeze,
      :T => %w(-).freeze,
      :U => %w(. . -).freeze,
      :V => %w(. . . -).freeze,
      :W => %w(. - -).freeze,
      :X => %w(- . . -).freeze,
      :Y => %w(- . - -).freeze,
      :Z => %w(- - . .).freeze,
      :"1" => %w(. - - - -).freeze,
      :"2" => %w(. . - - -).freeze,
      :"3" => %w(. . . - -).freeze,
      :"4" => %w(. . . . -).freeze,
      :"5" => %w(. . . . .).freeze,
      :"6" => %w(- . . . .).freeze,
      :"7" => %w(- - . . .).freeze,
      :"8" => %w(- - - . .).freeze,
      :"9" => %w(- - - - .).freeze,
      :"0" => %w(- - - - -).freeze
    }.freeze
    
    @seq_to_char = create_seq_map(@char_to_seq).freeze
    
    # Accepts an alphanumeric character and returns the corresponding
    # sequence of Morse Code signals.
    def self.sequence(char)
      key = char.to_s
      unless key.length == 1
        raise TypeError, "Expected a single character String or a Symbol as an argument: #{key}"
      end
      @char_to_seq[key.upcase.to_sym]
    end
    
    # Accepts a Morse Code sequence represented as a String, Array or Sequence instance and
    # returns the corresponding alphanumeric character.
    def self.character(seq)
      if seq.respond_to?(:to_sym)
        key = seq.to_sym
      elsif seq.respond_to?(:join)
        key = seq.join.to_sym
      else
        key = seq.to_s_to_sym
      end

      @seq_to_char[key]
    end
  end # Lookup
  Lookup.freeze
end