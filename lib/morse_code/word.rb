require 'morse_code/sequence'

module MorseCode
  #
  # A collection of Sequences representing a single word in Morse Code
  #
  class Word
    attr_reader :sequences
  
    # Initialize with a string of Morse Code text (space separated sequences)
    # or a list of sequence Strings or Sequence instances.
    def initialize(sequences)
      if sequences.respond_to?(:split)
        @sequences = sequences.split.map { |s| Sequence.new(s) }
      elsif sequences.respond_to?("[]")
        @sequences = sequences.map { |s| s.is_a?(Sequence) ? s : Sequence.new(s) }
      else
        raise TypeError, "Expected a String or a list of Sequences: #{sequences}"
      end
    end
  
    # Parses a single word of alphanumeric text and creates a new Word instance
    def self.parse(text)
      sequences = text.split(//).map { |c| Sequence.from_char(c) }
      new(sequences)
    end
  
    def eql?(other)
      if other.instance_of? Word
        self.equal?(other) || @sequences == other.sequences
      else
        false
      end
    end
  
    def ==(other)
      self.eql?(other)
    end
  
    def to_s
      @sequences.map { |s| s.to_s }.join(' ')
    end
  
    def to_alphanumeric
      @sequences.map { |s| s.to_alphanumeric }.join
    end
  end
end
