require_relative 'puzzle1'
RSpec.describe Puzzle1 do
  def self.with(definition = nil, file: nil, &block)
    definition ||= File.read(file)

    context "with '#{definition}'" do
      let(:definition) { definition }

      class_exec(&block)
    end
  end

  describe '#possible_games' do
    subject { puzzle.possible_games }
    let(:puzzle) { described_class.new(definition) }

    with file: 'sample1' do
      it do
        expected_games = [1,2,5].map { |n| an_object_having_attributes(id: n) }
        is_expected.to match_array(expected_games)
      end
    end
  end

  describe '#answer' do
    subject { puzzle.answer }
    let(:puzzle) { described_class.new(definition) }

    with file: 'sample1' do
      it { is_expected.to eq(8) }
    end
  end
end

RSpec.describe Puzzle1::Game do
  describe '.parse' do
    subject(:game) { described_class.parse(definition) }

    def self.with(definition, &block)
      context "with '#{definition}'" do
        let(:definition) { definition }

        class_exec(&block)
      end
    end

    with 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' do
      it { is_expected.to have_attributes(id: 1) }

      describe ".draws" do
        subject { game.draws }
        it { is_expected.to have_attributes(count: 3) }
        it do
          expected = [
            {blue: 3, red: 4},
            {red: 1, green: 2, blue: 6},
            {green: 2}
          ]
          is_expected.to eq(expected)
        end
      end
    end
  end
end
