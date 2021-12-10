require 'test_helper'

class ContentInputTest < Minitest::Test
  def test_to_html
    attr = :non_existent
    tag = Hellobase::Formtastic::Inputs::ContentInput.new(@builder, @template, @object, @object_name, attr, content: 'test content').to_html
    frag = Nokogiri::HTML::DocumentFragment.parse(tag)
    assert_equal 1, frag.children.length
    root = frag.children.first
    assert_equal 'li', root.name
    assert_equal "#{@object_name}_#{attr}_input", root.attributes['id'].value
    assert root.attributes['class'].value.split(' ').include? 'content'
    assert root.attributes['class'].value.split(' ').include? 'input'

    root_children = root.children.reject {|node| node.name == 'text' }
    assert_equal %w(label span), root_children.map(&:name)
    assert_equal 'test content', root_children[1].inner_html
  end
end