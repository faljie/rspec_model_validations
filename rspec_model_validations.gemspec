# frozen_string_literal: true

require_relative 'lib/rspec_model_validations/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec_model_validations'
  spec.version       = RspecModelValidations::VERSION
  spec.authors       = ['Pierre Guego']
  spec.email         = ['pierre.guego@champagne-terroir.fr']

  spec.summary       = 'Extra matchers to test model validation'
  spec.homepage      = 'https://github.com/faljie/rspec_model_validations'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
