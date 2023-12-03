require_relative 'puzzle1'

RSpec.describe Puzzle1 do
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

    with file: 'sample1' do
      it { is_expected.to eq(4361) }
    end
  end
end

RSpec.describe Puzzle1::Grid do
  def p(*values)
    values.map do |row, column|
      Puzzle1::Position.new(row, column)
    end
  end

  def self.with(definition, &block)
    context "with '#{definition}'" do
      let(:definition) { definition }

      class_exec(&block)
    end
  end

  describe '.parse' do
    subject(:grid) { described_class.parse(definition) }

    with '...' do
      it { is_expected.to have_attributes(width: 3) }
      it { is_expected.to have_attributes(height: 1) }
    end

    with '...|...|...' do
      it { is_expected.to have_attributes(width: 3) }
      it { is_expected.to have_attributes(height: 3) }
    end

    with '467..114&.|...*......|..35..633.' do
      it { is_expected.to have_attributes(width: 10)}
      it { is_expected.to have_attributes(height: 3) }

      describe '.contents' do
        subject { grid.contents }

        it do
          expected_contents = [
            an_object_having_attributes(row: 0, column: 0, content: "467"),
            an_object_having_attributes(row: 0, column: 5, content: "114"),
            an_object_having_attributes(row: 2, column: 2, content: "35"),
            an_object_having_attributes(row: 2, column: 6, content: "633"),
            an_object_having_attributes(row: 0, column: 8, content: "&"),
            an_object_having_attributes(row: 1, column: 3, content: "*")
          ]

          is_expected.to match_array(expected_contents)
        end
      end
    end
  end

  describe '.find_at' do
    let(:grid) { described_class.parse(definition) }
    subject { grid.find_at(position) }

    with '.@.x.#.' do
      def self.at(row:, column:, &block)
        position = Puzzle1::Position.new(row, column)

        context "at #{position}" do
          let(:position) { position }

          class_exec(&block)
        end
      end

      at row: 0, column: 0 do
        it { is_expected.to be_nil }
      end

      at row: 0, column: 3 do
        it { is_expected.to have_attributes(content: 'x') }
      end
    end
  end

  describe '.symbol_at?' do
    let(:grid) { described_class.parse(definition) }
    subject { grid.symbol_at?(*positions) }

    with '.1.#.' do
      def self.at(row:, column:, &block)
        position = Puzzle1::Position.new(row, column)

        context "at #{position}" do
          let(:positions) { [position] }

          class_exec(&block)
        end
      end

      at row: 0, column: 1 do
        it { is_expected.to be_falsy }
      end

      at row: 0, column: 2 do
        it { is_expected.to be_falsy }
      end

      at row: 0, column: 3 do
        it { is_expected.to be_truthy }
      end

      context "at [0,1] and [0,2]" do
        let(:positions) { p([0,1],[0,2]) }
        it { is_expected.to be_falsy }
      end

      context "at [0,2] and [0,3]" do
        let(:positions) { p([0,2],[0,3]) }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe '.numbers' do
    let(:grid) { described_class.parse(definition) }
    subject { grid.numbers }

    with '.x.' do
      it { is_expected.to be_empty }
    end

    with '467..114&.|...*......|..35..633.' do
      it do
        expected_contents = %w[35 633 114 467].map do |content|
          an_object_having_attributes content: content
        end
        is_expected.to match_array(expected_contents)
      end
    end
  end

  describe '.part_numbers' do
    let(:grid) { described_class.parse(definition) }
    subject { grid.part_numbers }

    with '.x.' do
      it { is_expected.to be_empty }
    end

    # 467..114&.
    # ...*......
    # ..35..633.
    with '467..114&.|...*......|..35..633.' do
      it do
        expected_part_numbers = [35,114,467].map do |value|
          an_object_having_attributes(content: value.to_s)
        end
        is_expected.to match_array(expected_part_numbers)
      end
    end
  end

end

RSpec.describe Puzzle1::Content do
  subject(:content) { Puzzle1::Content.new(content: 'dummy', row: 0, column: 0) }

  def positions(*values)
    values.map do |row, column|
      Puzzle1::Position.new(row, column)
    end
  end

  def self.with(attributes = {}, &block)
    content = described_class.new attributes

    context "with '#{content.inspect}'" do
      let(:content) { content }

      class_exec(&block)
    end
  end

  describe '#number?' do
    subject { content.number? }

    with content: 'x' do
      it { is_expected.to be_falsy }
    end

    with content: '12' do
      it { is_expected.to be_truthy }
    end
  end

  describe '#symbol?' do
    subject { content.symbol? }

    with content: 'x' do
      it { is_expected.to be_truthy }
    end

    with content: '12' do
      it { is_expected.to be_falsy }
    end
  end

  describe '#length' do
    subject { content.length }

    with content: 'x' do
      it { is_expected.to eq(1) }
    end

    with content: 'xxx' do
      it { is_expected.to eq(3) }
    end
  end

  describe '#used_positions' do
    subject { content.used_positions }

    with row: 2, column: 2, content: 'x' do
      it { is_expected.to match_array(positions([2,2])) }
    end

    with row: 2, column: 2, content: 'xxx' do
      it { is_expected.to match_array(positions([2,2],[2,3],[2,4])) }
    end
  end

  describe '#include?' do
    subject { content.include?(position) }
    let(:position) { double }

    context "when used_positions include given position" do
      before { allow(content).to receive(:used_positions).and_return([position]) }

      it { is_expected.to be_truthy }
    end

    context "when used_positions doesn't include given position" do
      before { allow(content).to receive(:used_positions).and_return([]) }

      it { is_expected.to be_falsy }
    end
  end

  describe '#neighborhood' do
    subject { content.neighborhood }

    with row: 2, column: 2, content: 'x' do
      it do
        expected_positions = positions(
          [ 1, 1 ], [ 1,2 ], [ 1,3 ],
          [ 2, 1 ], [ 2, 3],
          [ 3, 1 ], [ 3,2 ], [ 3,3 ]
        )

        is_expected.to match_array(expected_positions)
      end
    end

    with row: 2, column: 2, content: 'xxx' do
      it do
        expected_positions = positions(
          [ 1, 1 ], [ 1,2 ], [ 1,3 ], [1,4], [1,5],
          [ 2, 1 ], [ 2, 5],
          [ 3, 1 ], [ 3,2 ], [ 3,3 ], [ 3,4 ], [ 3,5 ]
        )

        is_expected.to match_array(expected_positions)
      end
    end
  end
end
