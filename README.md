# RspecModelValidations

*Extra matchers to improve testing of model validation*

Testing model validation can be a bit clunky:

* `model.valid?` test the entire model and it can lead to false positive in case of multiple validations
  ```ruby
    validates :attribute, presence: true, numericality: { greater_than: 6 })

    # numericality add errors when value is nil so presence validator can't be test
  ```
* Model validation must be run
* `model.errors.added?` test specific attribute / validation but options must be pass
  ```ruby
    model.attribute = 3
    model.validate
    expect(model.errors).to be_added(:attribute, :greater_than, value: 3, count: 6)
  ```
* `model.errors.messages_for` test specific attribute / validation but validator message must be pass
  ```ruby
    expect(model.errors[:attribute]).to include 'must be greater than 6'
  ```
* As validation are test through 'raw code' spec message can be hard to understand
  ```ruby
    # => expected `#<ActiveModel::Errors []>.added?(:attr, :not_a_number, {:value=>"invalid"})` to be truthy, got false
  ```

RspecModelValidations improve it by adding matchers to focus test on specific attribute / validation type.

```ruby
  model.attribute = 9

  expect(model).to validate :attribute
  expect(model).to invalidate(:attribute).with :greater_than

  # => expected 9 on ModelClass#attribute to be invalidated with greater_than
```

## Requirements

* ~> 1.0: rails ~> 7.0

*Note: it should be able to run with older version of rails but behaviour is not garented.*

## Installation

1. Add rspec_model_validations to your application in :test env

```ruby
  gem 'rspec_model_validations', '~> 1.0', require: false, groupe: :test
```

2. Setup rspec_model_validations in spec/rails_helper.rb file

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
  model.attribute = 'invalid'
  expect(model).to invalidate :attribute

  # equivalent to
  model.attribute = 9
  model.validate
  expect(model.errors[:attribute]).to be_present
```

Options:

* `with` specify which error type must be present. It accept single or multiple symbols.

```ruby
  model.attribute = 'invalid'
  expect(model).to invalidate(:attribute).with :blank, :not_a_number

  # equivalent to
  model.attribute = 9
  expect(model.errors.group_by_attribute(:attribute).map(&:type)).to include(:blank, :not_a_number)
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
