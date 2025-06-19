require "logger" # Fix concurrent-ruby 1.3.5 removing logger dependency which Rails itself does not have
require 'minitest/autorun'

# suppress warnings from gem dependencies
require 'warning'
Gem.path.each {|path| Warning.ignore(//, path) }

require 'hellobase/formtastic'

class Minitest::Test
  protected

  def assert_error(type, &block)
    begin
      yield
    rescue Hellobase::Error => e
      assert_equal type, e.type
      return
    end

    flunk "no #{type.inspect} error raised"
  end
end

require 'tod'
require 'rails/all'
require 'nokogiri'

class FormObject
  include ActiveModel::Attributes

  attr_accessor :array # TODO 'string_array' type
  attribute :boolean, :boolean
  attribute :datetime, :datetime
  attribute :time_of_day, :string # TODO 'time_only' type
end

class MockTemplate
  attr_accessor :output_buffer

  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
end

class Minitest::Test
  protected

  def setup
    @object_name = 'form_object'
    @object = FormObject.new
    @template = MockTemplate.new
    @builder = Formtastic::FormBuilder.new(@object_name, @object, @template, {})
  end
end
