RSpec.describe RspecModelValidations::Matchers do
  let(:dummy) do
    Class.new { include RspecModelValidations::Matchers }.new
  end

  describe '#validate' do
    subject { dummy.validate :attribute }

    it 'should build a Validate matcher with the given attribute' do
      expect(subject).to be_a RspecModelValidations::Matchers::Validate
      expect(subject.instance_variable_get '@attribute').to eq :attribute
    end
  end

  describe '#invalidate' do
    subject { dummy.invalidate :attribute }

    it 'should build an Invalidate matcher with the given attribute' do
      expect(subject).to be_a RspecModelValidations::Matchers::Invalidate
      expect(subject.instance_variable_get '@attribute').to eq :attribute
    end
  end
end
