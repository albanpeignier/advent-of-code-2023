require 'set'

class Puzzle2
  def initialize(input)
    @input = input
  end
  attr_reader :input

  def grid
    @grid ||= Grid.parse input
  end

  def answer
    grid.gears.map(&:ratio).map(&:to_i).sum
  end

  class Position < Struct.new(:row, :column)
    def to_s
      "#{row},#{column}"
    end
    alias inspect to_s
  end

  class Content
    def initialize(content:, position: nil, row: nil, column: nil)
      @content = content
      @position = position || Position.new(row, column)
    end

    attr_reader :position, :content

    def row
      position.row
    end

    def column
      position.column
    end

    def length
      content.length
    end

    def number?
      @number ||= /\d/.match?(content)
    end

    def symbol?
      !number?
    end

    def inspect
      "[#{position.inspect}] '#{content}'"
    end

    def used_positions
      @used_positions ||= (column..(column+length-1)).map do |column|
        Position.new row, column
      end
    end

    def include?(position)
      used_positions.include? position
    end

    def neighborhood
      [].tap do |neighborhood|
        ((row-1)..(row+1)).each do |row|
          ((column-1)..(column+length)).each do |column|
            position = Position.new row, column
            neighborhood << position unless include?(position)
          end
        end
      end
    end
  end

  class Gear
    def initialize(*numbers)
      @numbers = numbers
    end

    attr_reader :numbers

    def ratio
      numbers.inject(&:*)
    end
  end

  class Grid
    def initialize(attributes = {})
      attributes.each { |k,v| send "#{k}=",v }
    end

    LINE_FORMAT =/(\d+|[^\.])/
    # LINE_FORMAT =/(\d+)/

    def self.parse(definition)
      lines = definition.split(/\||\n/)

      grid = Grid.new(width: lines.map(&:size).max, height: lines.size)

      lines.each_with_index do |line, row|
        matches = line.to_enum(:scan, LINE_FORMAT).map { Regexp.last_match }
        matches.each do |match|
          column = match.begin(0)
          content = match.captures[0]

          grid.contents << Content.new(content: content, row: row, column: column)
        end
      end

      grid
    end

    attr_accessor :width, :height

    def contents
      @contents ||= []
    end

    def find_at(position)
      contents.find do |content|
        content.include?(position)
      end
    end

    def numbers_at(*positions)
      positions.flatten!

      Set.new.tap do |numbers|
        positions.each do |position|
          content = find_at(position)
          numbers << content if content&.number?
        end
      end
    end

    def stars
      contents.select { |content| content.content == "*"  }
    end

    def gears
      stars.map do |star|
        numbers = numbers_at(star.neighborhood)

        if numbers.size == 2
          values = numbers.map(&:content).map(&:to_i)
          Gear.new(*values)
        end
      end.compact
    end
  end
end

puts Puzzle2.new(STDIN.read).answer unless STDIN.tty?
