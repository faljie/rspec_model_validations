# frozen_string_literal: true

require_relative 'rspec_model_validations/version'

require_relative 'rspec_model_validations/matchers'
require_relative 'rspec_model_validations/matchers/base'
require_relative 'rspec_model_validations/matchers/validate'
require_relative 'rspec_model_validations/matchers/invalidate'

module RspecModelValidations
  class Error < StandardError; end
  # Your code goes here...
end
