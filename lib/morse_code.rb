require'morse_code/lookup'

module MorseCode

  # Indicates an invalid Morse Code signal (anything besides - or .)
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
  
  #
  # Collects Word objects to form Morse Code representation of a message
  #
  class Message
    DEFAULT_SEPARATOR = "//"
    
    attr_reader :words
    
    # Initialize with a String of Morse Code text. If a word separator is not
    # specified, DEFAULT_SEPARATOR is assumed. A list of Word instances is
    # also accepted.
    def initialize(words, sep=DEFAULT_SEPARATOR)
      @separator = sep
      if words.respond_to?(:split)
        @words = words.split(@separator).map { |w| Word.new(w) }
      elsif words.respond_to?("[]")
        @words = words.map { |w| w.is_a?(Word) ? w : Word.new(w)}
      else
        raise TypeError, "Expected a String or a list of Words: #{words}"
      end
    end
    
    def self.parse(text, sep=DEFAULT_SEPARATOR)
      words = text.split.map { |w| Word.parse(w) }
      new(words, sep)
    end
    
    def eql?(other)
      if other.instance_of? Message
        self.equal?(other) || self.words == other.words
      else
        false
      end
    end
    
    def ==(other)
      self.eql?(other)
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
      Message.new(text, separator).to_alphanumeric
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