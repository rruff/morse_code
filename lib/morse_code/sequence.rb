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
end # MorseCode