class Puzzle2
  def initialize(input)
    @input = input
  end
  attr_reader :input

  def lines
    @lines ||= input.split("\n")
  end

  def values
    @values ||= lines.map { |l| CalibrationValue.new(l) }
  end

  class DigitReader
    def initialize(definition)
      @definition = definition
    end
    attr_reader :definition

    DIGITS = %w{one two three four five six seven eight nine}

    def regexp_defintion
      "(#{DIGITS.join('|')})"
    end

    def regexp
      Regexp.new regexp_defintion
    end

    def values
      DIGITS.map.each_with_index do |name, index|
        value = (index + 1).to_s
        [ name, value ]
      end.to_h
    end

    def read
      definition.gsub regexp, values
    end
  end

  class DigitScanner
    def initialize(definition, reverse: false)
      @definition = definition
      @reverse = reverse
    end
    attr_reader :definition

    def reverse?
      @reverse
    end

    SPELLED_DIGITS = %w{one two three four five six seven eight nine}

    def self.spelled
      SPELLED_DIGITS
    end

    NUMERIC_DIGITS = (1..9).map(&:to_s)

    def self.numerics
      NUMERIC_DIGITS
    end

    def spelled
      @spelled ||= self.class.spelled.dup.tap do |spelled|
        spelled.map!(&:reverse) if reverse?
      end
    end

    def numerics
      self.class.numerics
    end

    def value(text)
      if spelled_index = spelled.index(text)
        spelled_index + 1
      else
        text.to_i
      end
    end

    def regexp_definition
      "(#{(spelled + numerics).join('|')})"
    end

    def regexp
      @regexp ||= Regexp.new(regexp_definition)
    end

    def matched_definition
      reverse? ? definition.reverse : definition
    end

    def match
      @match ||= regexp.match(matched_definition)
    end

    def first
      value(match.captures.first)
    end
  end

  class CalibrationValue
    def initialize(definition)
      @definition = definition
    end
    attr_reader :definition


    def scanner
      DigitScanner.new(definition)
    end

    def first_digit
      scanner.first
    end

    def reversed_scanner
      DigitScanner.new(definition, reverse: true)
    end

    def last_digit
      reversed_scanner.first
    end

    def number
      (first_digit * 10 + last_digit).to_i
    end
  end

  def answer
    values.map(&:number).sum
  end
end

puts Puzzle2.new(STDIN.read).answer unless STDIN.tty?
