require 'test_helper'

class InlineCheckboxInputTest < Minitest::Test
  def test_to_html
    attr = :boolean
    tag = Hellobase::Formtastic::Inputs::InlineCheckboxInput.new(@builder, @template, @object, @object_name, attr, {}).to_html
    frag = Nokogiri::HTML::DocumentFragment.parse(tag)
    assert_equal 1, frag.children.length
    root = frag.children.first
    assert_equal 'li', root.name
    assert_equal "#{@object_name}_#{attr}_input", root.attributes['id'].value
    assert root.attributes['class'].value.split(' ').include? 'inline_checkbox'
    assert root.attributes['class'].value.split(' ').include? 'input'

    root_children = root.children.reject {|node| node.name == 'text' }
    assert_equal %w(input label input), root_children.map(&:name)

    hidden_field = root_children[0]
    assert_equal 'hidden', hidden_field.attributes['type'].value
    assert_equal "#{@object_name}[#{attr}]", hidden_field.attributes['name'].value

    checkbox = root_children[2]
    assert_equal 'checkbox', checkbox.attributes['type'].value
    assert_equal "#{@object_name}_#{attr}", checkbox.attributes['id'].value
    assert_equal "#{@object_name}[#{attr}]", checkbox.attributes['name'].value
  end
end