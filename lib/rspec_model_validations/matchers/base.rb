# frozen_string_literal: true

# Dry matcher code
module RspecModelValidations::Matchers::Base
  # @param attribute [Symbol, String]
  def initialize attribute
    @attribute = attribute.to_s.to_sym
    @model = nil
    @errors = nil
  end

  # Store given value
  # @param value [Object]
  # @return [self]
  def on value
    @on = value

    self
  end

  private

  # Raise an error if model does not posses @attribute
  # @param model [ActiveModel::Model]
  def attribute_belongs_to! model
    return if model.respond_to? @attribute

    message = "#{@attribute.inspect} is not a #{model.class} attribute !"
    raise RspecModelValidations::Error, message
  end

  # Run model validations and return attribute errors type
  # Set model attribute with on value when on is set.
  # @param model [ActiveModel::Model]
  # @return [Array]
  def attribute_errors model
    model.attributes = { @attribute => @on } if defined? @on
    model.validate
    model.errors.group_by_attribute[@attribute]&.map(&:type) || []
  end

  # Return the model attribute value.
  # Attribute must exist
  # @param model [ActiveModel::Model]
  # @return [Object]
  def attribute_value model; model.send @attribute end

  # Format a matcher expected / got faillure message
  # @param expected [String] expected part of the message
  # @param got [String] got part of the message
  # @return [String]
  def message expected, got; "\nexpected: #{expected}\n     got: #{got}" end
end
