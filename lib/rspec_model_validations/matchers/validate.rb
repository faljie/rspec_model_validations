# frozen_string_literal: true

# Test if model validation does not lead to errors on the given attribute.
class RspecModelValidations::Matchers::Validate
  include RspecModelValidations::Matchers::Base

  # Run the test
  # @param model[ActiveModel::Model]
  # @return [Boolean] Test result
  # @raise [RspecModelValidations::Error] When model does not posses the given attribute
  def matches? model
    attribute_belongs_to! model

    @model = model
    @errors = attribute_errors model

    @errors.empty?
  end

  # Explain why matches? fail and show errors
  # @return [String]
  def failure_message
    message "#{attribute_value(@model).inspect} to be a valid value for #{@model.class}##{@attribute}", @errors
  end

  # Explain why matches? fail when negated
  # @return [String]
  def failure_message_when_negated
    message "#{attribute_value(@model).inspect} to be an invalid value for #{@model.class}##{@attribute}", @errors
  end

  # One line syntax description
  # @return [String]
  def description; "validate #{@attribute.inspect} attribute" end
end
