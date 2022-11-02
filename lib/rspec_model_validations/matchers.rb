# Rspec 'alias' to run matchers.
# Include with rspec configuration method `include`
module RspecModelValidations::Matchers
  # `validate` alias
  # @return [Validate]
  def validate attribute; Validate.new attribute end

  # `invalidate` alias
  # @return [Validate]
  def invalidate attribute; Invalidate.new attribute end
end
