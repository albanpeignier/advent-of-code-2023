require_relative 'puzzle2'

RSpec.describe Puzzle2 do
  describe '#answer' do
    subject { puzzle.answer }
    let(:puzzle) { described_class.new(definition) }

    def self.with(definition = nil, file: nil, &block)
      definition ||= File.read(file)

      context "with '#{definition}'" do
        let(:definition) { definition }

        class_exec(&block)
      end
    end

    with file: 'sample2' do
      it { is_expected.to eq(281) }
    end

  end
end

RSpec.describe Puzzle2::DigitScanner do
  describe '.spelled' do
    subject { described_class.spelled }

    it { is_expected.to eq(%w{one two three four five six seven eight nine}) }
  end

  describe '.numerics' do
    subject { described_class.numerics }

    it { is_expected.to eq(%w{1 2 3 4 5 6 7 8 9}) }
  end

  describe '#regex_definition' do
    subject { described_class.new("dummy").regexp_definition }

    it { is_expected.to eq("(one|two|three|four|five|six|seven|eight|nine|1|2|3|4|5|6|7|8|9)") }

    context 'in reverse mode' do
      subject { described_class.new("dummy",reverse: true).regexp_definition }

      it { is_expected.to eq("(eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|1|2|3|4|5|6|7|8|9)") }
    end
  end

  describe '#first' do
    subject { described_class.new(definition, reverse: reverse).first }

    def self.with(definition, reverse: false, &block)
      reverse_context = " in reverse mode" if reverse
      context "with '#{definition}'#{reverse_context}" do
        let(:definition) { definition }
        let(:reverse) { reverse }

        class_exec(&block)
      end
    end

    with 'one' do
      it { is_expected.to eq(1) }
    end

    with '1' do
      it { is_expected.to eq(1) }
    end

    with 'somethingone' do
      it { is_expected.to eq(1) }
    end

    with 'something1' do
      it { is_expected.to eq(1) }
    end

    with 'somethingone2' do
      it { is_expected.to eq(1) }
    end

    with 'something1two' do
      it { is_expected.to eq(1) }
    end

    with 'one', reverse: true do
      it { is_expected.to eq(1) }
    end

    with 'onetwo', reverse: true do
      it { is_expected.to eq(2) }
    end

    with '3two3eightjszbfourkxbh5twonepr', reverse: true do
      it { is_expected.to eq(1) }
    end


  end

end
