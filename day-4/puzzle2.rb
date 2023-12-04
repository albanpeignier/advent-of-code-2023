class Puzzle2
  def initialize(input)
    @input = input
  end
  attr_reader :input

  def cards
    @cards ||= Card.parse(input).map do |card|
      [ card.id, card ]
    end.to_h
  end

  def scratch_cards
    @scratch_cards ||= []
  end

  def answer
    stack = []

    stack.concat cards.values

    while !stack.empty?
      card = stack.shift
      scratch_cards << card
      stack.concat cards.values_at(*card.won_card_ids)
    end

    scratch_cards.size
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

    def won_card_ids
      return [] if winning_numbers.empty?

      (id+1)..(id+winning_numbers.size)
    end
  end
end

puts Puzzle2.new(STDIN.read).answer unless STDIN.tty?
