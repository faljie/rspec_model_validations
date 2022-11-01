# Test if model validation does not lead to errors on the given attribute.
class RspecModelValidations::Matchers::Validate
  # @param attribute [Symbol, String]
  def initialize attribute
    @attribute = attribute.to_s.to_sym
    @model = nil
    @errors = nil
  end

  # Run the test
  # @param model[ActiveModel::Model]
  # @return [Boolean] Test result
  # @raise [RspecModelValidations::Error] When model does not posses the given attribute
  def matches? model
    attribute_belongs_to! model
    @model = model

    model.validate
    @errors = model.errors.group_by_attribute[@attribute]&.map(&:type)

    @errors.nil?
  end

  # Explain why matches? fail and show errors
  # @return [String]
  def failure_message
    value = @model.instance_variable_get "@#{@attribute}"

    "\nexpected: #{value.inspect} to be a valid value for #{@model.class}##{@attribute}\n     got: #{@errors}"
  end

  # Explain why matches? fail when negated
  # @return [String]
  def failure_message_when_negated
    value = @model.instance_variable_get "@#{@attribute}"

    "\nexpected: #{value.inspect} to be an invalid value for #{@model.class}##{@attribute}\n     got: []"
  end

  # One line syntax description
  # @return [String]
  def description; "validate #{@attribute.inspect} attribute" end

  private

  # Raise an error if model does not posses @attribute
  def attribute_belongs_to! model
    return if model.respond_to? @attribute

    message = "#{@attribute.inspect} is not a #{model.class} attribute !"
    raise RspecModelValidations::Error, message
  end
end
