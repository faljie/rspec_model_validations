RSpec.describe RspecModelValidations::Matchers::Invalidate do
  let(:model) do
    build_dummy do
      attr_accessor :target, :other

      validates :other, presence: true
      validates :target, presence: true
    end.new target: :valid, other: :valid
  end

  let(:instance) { described_class.new :target }

  describe '#matches?' do
    subject { instance.matches? model }

    it 'should run validation' do
      model.target = nil

      expect { subject }.to change { model.errors.count }
    end

    context 'when target have not any error' do
      it { should be_falsy }

      context 'when other is valid' do
        it { should be_falsy }
      end

      context 'when other is invalid' do
        before { model.other = nil }

        it { should be_falsy }
      end
    end

    context 'when target have at least one error' do
      before { model.target = nil }

      it { should be_truthy }

      context 'when other is valid' do
        it { should be_truthy }
      end

      context 'when other is invalid' do
        before { model.other = nil }

        it { should be_truthy }
      end
    end

    context 'when target is not a model attribute' do
      let(:instance) { described_class.new :unknow }

      it 'should raise an error' do
        expect { subject }.to raise_error RspecModelValidations::Error
      end
    end
  end

  describe '#failure_message' do
    before { instance.matches? model }
    subject { instance.failure_message }

    it { should eq "\nexpected: :valid to be an invalid value for #{model.class}#target\n     got: []" }
  end

  describe '#failure_message_when_negated' do
    before do
      model.target = nil
      instance.matches? model
    end
    subject { instance.failure_message_when_negated }

    it { should eq "\nexpected: nil to be a valid value for #{model.class}#target\n     got: [:blank]" }
  end

  describe '#description' do
    subject { instance.description }

    it { should eq 'invalidate :target attribute' }
  end
end
