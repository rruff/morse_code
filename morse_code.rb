#! /usr/bin/env ruby

module MorseCode
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

  class InvalidSignalError < StandardError
    attr_reader :signal
    
    def initialize(signal)
      @signal = signal
    end
  end
  
  #
  # A sequence of Morse Code signals representing a single character
  #
  class Sequence
    attr_reader :signals
  
    def initialize(signals, char=nil)
      if valid(signals)
        @signals = signals.respond_to?(:split) ? signals.split(//) : signals
        @char = char
      else
        raise InvalidSignalError.new(signals), "Only dashes (-) and dots (.) are valid signals"
      end
    end
    
    def self.from_char(c)
      new(Lookup.sequence(c), c)
    end
    
    def ==(other)
      self.eql?(other)
    end
  
    def eql?(other)
      if other.is_a? Sequence
        self.equal?(other) or @signals == other.signals
      else
        false
      end
    end
    
    def to_s
      @signals.join
    end
    
    def to_sym
      self.to_s.to_sym
    end
    
    def to_alphanumeric
      @char ||= Lookup.character(self)
    end

    def valid(signals)
      invalid = /[^-\.]/
      if signals.respond_to?(:match)
        !signals.match(invalid)
      elsif signals.respond_to?(:none?)
        signals.none? { |s| invalid.match(s) }
      else
        false
      end
    end
    private :valid
  end # Sequence
  
  #
  # A collection of Sequences representing a single word in Morse Code
  #
  class Word
    attr_reader :sequences
    
    def initialize(sequences)
      @sequences = sequences
    end
    
    # Parses a single word of alphanumeric text and creates a new Word instance
    def self.parse(text)
      sequences = text.split(//).map { |c| Sequence.from_char(c) }
      new(sequences)
    end
    
    def to_s
      @sequences.map { |s| s.to_s }.join(' ')
    end
    
    def to_alphanumeric
      @sequences.map { |s| s.to_alphanumeric }.join
    end
  end
  
  #
  # Collects Word objects to form Morse Code representation of a message
  #
  class Message
    DEFAULT_SEPARATOR = "//"
    
    attr_reader :words
    
    def initialize(words, sep=DEFAULT_SEPARATOR)
      @words = words
      @separator = sep
    end
    
    def self.parse(text, sep=DEFAULT_SEPARATOR)
      words = text.split.map { |w| Word.parse(w) }
      new(words, sep)
    end
    
    def to_s
      @words.map { |w| w.to_s }.join(@separator)
    end
    
    def to_alphanumeric
      @words.map { |w| w.to_alphanumeric }.join(' ')
    end
  end

  # Take a string of Morse Code text or an instance of Message, Word or Sequence
  # and return the aplhanumeric text equivalent.
  def self.to_alphanumeric(text, separator=Message::DEFAULT_SEPARATOR)
    # If +text+ is already one of the MorseCode::* types...
    if text.respond_to?(:to_alphanumeric)
      text.to_alphanumeric
    else
      # .... . .-.. .-.. ---//.-- --- .-. .-.. -.. (Hello World)
      words = text.split(separator).map do |w|
        # 1: .... . .-.. .-.. --- (Hello)
        # 2: .-- --- .-. .-.. -.. (World)
        sequences = w.split(' ').map { |c| Sequence.new(c) }
        Word.new(sequences)
      end
      Message.new(words).to_alphanumeric
    end
  end
    
  # Take a string of alphanumeric text and return the equivalent
  # string of Morse Code text.
  def self.from_alphanumeric(text, separator=Message::DEFAULT_SEPARATOR)
    Message.parse(text, separator).to_s
  end
  
end # MorseCode

# Open the built in String class and add
# a to_mc method
class String
  # Return a MorseCode::Message instance representing the current string
  # mc = "Hello World".to_mc
  # puts mc # => .... . .-.. .-.. ---//.-- --- .-. .-.. -..
  def to_mc
    MorseCode::Message.parse(self)
  end
end

#
# Run as a stand alone program
#
if __FILE__ == $0
  hello_mc = MorseCode.from_alphanumeric("Hello World")
  puts hello_mc
  
  puts MorseCode.to_alphanumeric(hello_mc)
end