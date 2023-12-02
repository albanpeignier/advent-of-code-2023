class Puzzle1
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

  class CalibrationValue
    def initialize(definition)
      @definition = definition
    end
    attr_reader :definition

    def digits
      @digits ||= definition.scan(/\d/)
    end

    def first_digit
      digits.first
    end

    def last_digit
      digits.last
    end

    def number
      (first_digit + last_digit).to_i
    end
  end

  def answer
    values.map(&:number).sum
  end
end

puts Puzzle1.new($stdin.read).answer
