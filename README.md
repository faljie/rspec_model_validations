===> implement on to set value
===> inspiration shoulda / rails rspec
  allow value
  custom matcher pas gerer
# RspecModelValidations

*Extra matchers to improve testing of model validation*

Testing model validation can be a bit clunky:
* `model.valid?` test the entire model so it can lead to errors
* specific error on attribute can be test with `model.added?` or `errors[:attribute]` but options or message must be provided
* attribute setting and validation trigger must be call
* as validation are test through "raw code" failure message can be hard to understand

`rspec_model_validations` make testing smoother by adding matchers to focus test on specific attribute / validation.

```ruby
  # model
  validates :attribute, numericality: true

  # spec
  expect(model).to invalidate(:attribute).with(:blank, :not_a_number).on nil

  # equivalent to
  model.attribute = nil
  model.validate
  expect(model.errors).to be_added :attribute, :blank
  expect(model.errors).to be_added :attribute, :not_a_number, value: nil
```

## Requirements

* ~> 1.0: rails ~> 7.0

*Note: it should be able to run with older version of rails but behaviour is not garented.*

## Installation

1. Add this gem to your application in :test env

```ruby
  gem 'rspec_model_validations', '~> 1.0', require: false, group: :test
```

2. Setup spec/rails_helper.rb file to access matchers

```ruby
  # Add additional requires below this line. Rails is not loaded until this point!
  require 'rspec_model_validations'

  # ...

  RSpec.configure do |config|
    config.include RspecModelValidations::Matchers
  end
```

## Usage

### Test validation errors

`invalidate :attribute` test errors on a specific attribute.
It run validation and test that the targeted attribute have at least one error.

```ruby
  model.attribute = nil
  expect(model).to invalidate :attribute

  # equivalent to
  model.attribute = nil
  model.validate
  expect(model.errors[:attribute]).to be_present
```

Options:

* `with` specify which errors type must be present. It accept single or multiple symbols.

```ruby
  model.attribute = nil
  expect(model).to invalidate(:attribute).with :blank, :not_a_number

  # equivalent to
  model.attribute = nil
  model.validate
  expect(model.errors.group_by_attribute(:attribute).map(&:type)).to include(:blank, :not_a_number)
```

* `on` set the attribute value

```ruby
  expect(model).to invalidate(:attribute).on nil

  # equivalent to
  model.attribute = nil
  model.validate
  expect(model.errors[:attribute]).to be_present
```

### Test successfull validation

`validate :attribute` test a specific attribute validity.
It run validation and then test that none errors are related to the given attribute.

```ruby
  model.attribute = 9
  expect(model).to validate :attribute

  # equivalent to
  model.attribute = 9
  model.validate
  expect(model.errors[:attribute]).to be_empty
```

Options:
  * `on` see invalidate on option
