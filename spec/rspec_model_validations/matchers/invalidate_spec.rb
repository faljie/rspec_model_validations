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

    context 'when option with is set' do
      let(:model) do
        build_dummy do
          attr_accessor :target

          validates :target, presence: true, numericality: { greater_than: 9 }
        end.new target: 12
      end
      before { instance.with :blank, :not_a_number }

      context 'when target have not errors' do
        it { should be_falsy }
      end

      context 'when target have not all the with errors' do
        before { model.target = 'invalid' }

        it { should be_falsy }
      end

      context 'when target have the with errors' do
        before { model.target = nil }

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

    context 'when option with is set' do
      before { instance.with :blank }

      it { should eq "\nexpected: #{model.class}#target to invalidate :valid with :blank\n     got: []" }
    end
  end

  describe '#failure_message_when_negated' do
    before do
      model.target = nil
      instance.matches? model
    end
    subject { instance.failure_message_when_negated }

    it { should eq "\nexpected: nil to be a valid value for #{model.class}#target\n     got: [:blank]" }

    context 'when option with is set' do
      before { instance.with :blank }

      it { should eq "\nexpected: #{model.class}#target not to invalidate nil with :blank\n     got: [:blank]" }
    end
  end

  describe '#description' do
    subject { instance.description }

    it { should eq 'invalidate :target attribute' }

    context 'when option with is set' do
      before { instance.with :blank, :not_a_number }

      it { should eq 'invalidate :target attribute with :blank, :not_a_number' }
    end
  end
end
