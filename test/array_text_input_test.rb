require 'test_helper'

class ArrayTextInputTest < Minitest::Test
  def test_to_html
    tag = Hellobase::Formtastic::Inputs::ArrayTextInput.new(@builder, @template, @object, @object_name, @attr, {}).to_html
    frag = Nokogiri::HTML::DocumentFragment.parse(tag)
    assert_equal 1, frag.children.length
    root = frag.children.first
    assert_equal 'li', root.name
    assert_equal "#{@object_name}_#{@attr}_input", root.attributes['id'].value
    assert root.attributes['class'].value.split(' ').include? 'array_text'
    assert root.attributes['class'].value.split(' ').include? 'input'

    root_children = root.children.reject {|node| node.name == 'text' }
    assert_equal %w(label textarea), root_children.map(&:name)
    assert_equal "#{@object_name}_#{@attr}", root_children[1].attributes['id'].value
    assert_equal "#{@object_name}[_stra_#{@attr}_text]", root_children[1].attributes['name'].value
  end

  private

  def setup
    super

    @attr = :array
    unless @object.respond_to?(Hellobase::Formtastic::Inputs::ArrayTextInput.virtual_attributes(@attr).first)
      Hellobase::Formtastic::Inputs::ArrayTextInput.define_virtual_attributes @object.class, @attr
    end
  end
end
