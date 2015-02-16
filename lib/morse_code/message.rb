require 'morse_code/word'

module MorseCode
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
end
