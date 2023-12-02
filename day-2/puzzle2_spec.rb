require_relative 'puzzle2'

RSpec.describe Puzzle2 do
  def self.with(definition = nil, file: nil, &block)
    definition ||= File.read(file)

    context "with '#{definition}'" do
      let(:definition) { definition }

      class_exec(&block)
    end
  end

  describe '#answer' do
    subject { puzzle.answer }
    let(:puzzle) { described_class.new(definition) }

    with 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' do
      it { is_expected.to eq(48) }
    end

    with 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue' do
      it { is_expected.to eq(12) }
    end

    with file: 'sample1' do
      it { is_expected.to eq(2286) }
    end
  end
end

RSpec.describe Puzzle2::Game do
  def self.with(definition, &block)
    context "with '#{definition}'" do
      let(:definition) { definition }

      class_exec(&block)
    end
  end

  describe '.parse' do
    subject(:game) { described_class.parse(definition) }

    with 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' do
      it { is_expected.to have_attributes(id: 1) }

      describe ".draws" do
        subject { game.draws }
        it { is_expected.to have_attributes(count: 3) }
        it do
          expected = [
            an_object_having_attributes(blue: 3, red: 4),
            an_object_having_attributes(red: 1, green: 2, blue: 6),
            an_object_having_attributes(green: 2)
          ]
          is_expected.to match_array(expected)
        end
      end
    end
  end

  describe '#maximum_counts' do
    subject { game.maximum_counts }
    let(:game) { described_class.parse(definition) }

    with 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' do
      it { is_expected.to include(red: 4, green: 2, blue: 6) }
    end

    with 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue' do
      it { is_expected.to include(red: 1, green: 3, blue: 4) }
    end
  end
end
