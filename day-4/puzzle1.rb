class Puzzle1
  def initialize(input)
    @input = input
  end
  attr_reader :input

  def cards
    @cards ||= Card.parse input
  end

  def answer
    cards.each do |card|
      puts [ card.draw, card.numbers, card.winning_numbers, card.points ].inspect
    end
    cards.map(&:points).sum
  end

  class Card
    def initialize(attributes = {})
      attributes.each { |k,v| send "#{k}=",v }
    end

    attr_accessor :id, :draw, :numbers

    CARD_FORMAT = /Card *(\d+): ([\d ]+) \| ([\d ]+)/

    def self.parse(definition)
      lines = definition.split("\n")

      lines.map do |line|
        CARD_FORMAT =~ line
        puts line
        Card.new(
          id: $1.to_i,
          draw: $2.split(" ").map(&:to_i).sort,
          numbers: $3.split(" ").map(&:to_i).sort
        )
      end
    end

    def winning_numbers
      draw & numbers
    end

    def points
      2.pow(winning_numbers.size - 1).to_i
    end
  end
end

puts Puzzle1.new(STDIN.read).answer unless STDIN.tty?
