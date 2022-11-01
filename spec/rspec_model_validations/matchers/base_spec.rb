RSpec.describe RspecModelValidations::Matchers::Base do
  let(:model) do
    build_dummy do
      attr_accessor :target

      validates :target, presence: true
    end.new target: :valid
  end

  let(:dummy) do
    Class.new do
      attr_reader :errors

      include RspecModelValidations::Matchers::Base

      def message expected, got; super end
      def attribute_belongs_to! model; super end
      def attribute_errors model; super end
      def attribute_value model; super end
    end
  end
  let(:instance) { dummy.new :target }

  describe '#attribute_belongs_to!' do
    subject { instance.attribute_belongs_to! model }

    context 'when attribute is a model attribute' do
      it 'should not raise an error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when attribute is not a model attribute' do
      let(:instance) { dummy.new :unknow }

      it 'should raise an error' do
        expect { subject }.to raise_error RspecModelValidations::Error
      end
    end
  end

  describe '#attribute_errors' do
    before { model.target = nil }
    subject { instance.attribute_errors model }

    it 'should run model validations' do
      expect { subject }.to change { model.errors.count }
    end

    it { should eq [:blank] }

    context 'when attribute does not have error' do
      before { model.target = :valid }

      it { should eq [] }
    end
  end

  describe '#attribute_value' do
    subject { instance.attribute_value model }

    it { should eq :valid }
  end

  describe '#message' do
    subject { instance.message 'first', 'second' }

    it { should eq "\nexpected: first\n     got: second" }
  end
end
