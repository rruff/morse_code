require 'morse_code/lookup'
require 'morse_code/sequence'
require 'morse_code/word'
require 'morse_code/message'

module MorseCode
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
