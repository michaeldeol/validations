require 'test_helper'

describe Lotus::Validations do
  describe 'format' do
    it "is valid if it doesn't have attributes" do
      validator = FormatValidatorTest.new({})

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "is valid if it respects given formats" do
      validator = FormatValidatorTest.new({name: 'Luca', age: 32})

      validator.valid?.must_equal true
      validator.errors.must_be_empty
    end

    it "isn't valid if one doesn't respect given formats" do
      validator = FormatValidatorTest.new({name: 'Luca', age: 'thirtytwo'})

      validator.valid?.must_equal false
      validator.errors.fetch(:age).must_include :format
    end
  end
end