require 'test_helper'

class TimeOfDayInputTest < Minitest::Test
  def test_to_html
    attr = :time_of_day
    tag = Hellobase::Formtastic::Inputs::TimeOfDayInput.new(@builder, @template, @object, @object_name, attr, {}).to_html
    frag = Nokogiri::HTML::DocumentFragment.parse(tag)
    assert_equal 1, frag.children.length
    root = frag.children.first
    assert_equal 'li', root.name
    assert_equal "#{@object_name}_#{attr}_input", root.attributes['id'].value
    assert root.attributes['class'].value.split(' ').include? 'time_of_day'
    assert root.attributes['class'].value.split(' ').include? 'input'

    root_children = root.children.reject {|node| node.name == 'text' }
    assert_equal %w(label select), root_children.map(&:name)
    assert_equal "#{@object_name}_#{attr}", root_children[1].attributes['id'].value
  end
end