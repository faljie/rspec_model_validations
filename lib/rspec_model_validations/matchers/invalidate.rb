# frozen_string_literal: true

# Test if model validation lead to errors on the given attribute.
#
# Option:
#   * `with` test that the attribute have specific error rather than any
class RspecModelValidations::Matchers::Invalidate
  include RspecModelValidations::Matchers::Base

  def initialize attribute
    super

    @with = nil
  end

  # Set the with option
  # @param errors [*Symbol] One or more error which should be in attribute errors
  def with *errors; @with = errors end

  # Run the test
  # @param model[ActiveModel::Model]
  # @return [Boolean] Test result
  # @raise [RspecModelValidations::Error] When model does not posses the given attribute
  def matches? model
    attribute_belongs_to! model

    @model = model
    @errors = attribute_errors model

    @errors.count != 0 && (@with.nil? || (@with & @errors) == @with)
  end

  # Explain why matches? fail
  # @return [String]
  def failure_message
    attribute = "#{@model.class}##{@attribute}"
    value = attribute_value(@model).inspect

    expected = "#{value} to be an invalid value for #{attribute}"
    expected = "#{attribute} to invalidate #{value} with #{@with.map(&:inspect).join ', '}" unless @with.nil?

    message expected, @errors
  end

  # Explain why matches? fail when negated
  # @return [String]
  def failure_message_when_negated
    attribute = "#{@model.class}##{@attribute}"
    value = attribute_value(@model).inspect

    expected = "#{value} to be a valid value for #{attribute}"
    expected = "#{attribute} not to invalidate #{value} with #{@with.map(&:inspect).join ', '}" unless @with.nil?

    message expected, @errors
  end

  # One line syntax description
  # @return [String]
  def description
    result = "invalidate #{@attribute.inspect} attribute"
    result = "#{result} with #{@with.map(&:inspect).join ', '}" unless @with.nil?

    result
  end
end
