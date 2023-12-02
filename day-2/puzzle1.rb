class Puzzle1
  def initialize(input)
    @input = input
  end
  attr_reader :input

  def lines
    @lines ||= input.split("\n")
  end

  def games
    @games ||= lines.map { |l| Game.parse(l) }
  end

  def counts
    Counts.new(red: 12, green: 13, blue: 14)
  end

  class Counts
    def initialize(counts = {})
      @counts = counts
    end

    def inspect
      @counts.inspect
    end

    def self.colors
      %i{red green blue}
    end

    colors.each do |color|
      define_method(color) do
        @counts[color] || 0
      end
    end

    def include?(other)
      self.class.colors.all? do |color|
        send(color) >= other.send(color)
      end
    end
  end

  class Game
    def initialize(attributes = {})
      attributes.each { |k,v| send "#{k}=", v }
    end

    # Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    def self.parse(definition)
      name, draw_definitions = definition.split(":")

      match = /Game (?<id>\d+)/.match(name)
      id = match["id"].to_i

      draws = draw_definitions.split(';').map do |draw_definition|
        values = draw_definition.split(',').map do |cubes|
          match = /(?<count>\d+) (?<color>red|green|blue)/.match(cubes)
          [ match["color"].to_sym, match["count"].to_i ]
        end.to_h

        Counts.new(values)
      end

      new id: id, draws: draws
    end

    attr_accessor :id

    def draws
      @draws ||= []
    end
    attr_writer :draws
  end

  def possible_games
    games.select do |game|
      game.draws.all? do |draw|
        counts.include?(draw)
      end
    end
  end

  def answer
    possible_games.map(&:id).sum
  end
end

puts Puzzle1.new(STDIN.read).answer unless STDIN.tty?
