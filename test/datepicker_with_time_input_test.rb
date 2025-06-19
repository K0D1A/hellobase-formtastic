require 'test_helper'

class DatepickerWithTimeInputTest < Minitest::Test
  def test_without_timezone
    run_test
  end

  def test_with_timezone
    run_test 'America/Los_Angeles'
  end

  private

  def setup
    super

    @attr = :datetime
    unless @object.respond_to?(Hellobase::Formtastic::Inputs::DatepickerWithTimeInput.virtual_attributes(@attr).first)
      Hellobase::Formtastic::Inputs::DatepickerWithTimeInput.define_virtual_attributes @object.class, @attr
    end
  end

  def run_test(timezone = nil)
    tag = Hellobase::Formtastic::Inputs::DatepickerWithTimeInput.new(@builder, @template, @object, @object_name, @attr, timezone: timezone).to_html
    root = parse_and_check_root(tag)
    root_children = root.children.reject {|node| node.name == 'text' }
    assert_equal ['span'] * 4 << 'input', root_children.map(&:name) # wrappers
    check_inputs(root_children, timezone)
  end

  def parse_and_check_root(tag)
    frag = Nokogiri::HTML::DocumentFragment.parse(tag)
    assert_equal 1, frag.children.length
    root = frag.children.first
    assert_equal 'li', root.name
    assert_equal "#{@object_name}_#{@attr}_input", root.attributes['id'].value
    assert root.attributes['class'].value.split(' ').include? 'datepicker_with_time'
    assert root.attributes['class'].value.split(' ').include? 'input'

    root
  end

  def check_inputs(root_children, timezone)
    datepicker_children = root_children[0].children.reject {|node| node.name == 'text' }
    assert_equal %w(label input), datepicker_children.map(&:name)
    assert_equal "#{@object_name}__dpwt_#{@attr}_d", datepicker_children[1].attributes['id'].value
    assert_equal 'text', datepicker_children[1].attributes['type'].value
    assert datepicker_children[1].attributes['class'].value.split(' ').include? 'datepicker'

    hour_select_children = root_children[1].children.reject {|node| node.name == 'text' }
    assert_equal %w(select), hour_select_children.map(&:name)
    assert_equal "#{@object_name}__dpwt_#{@attr}_h", hour_select_children[0].attributes['id'].value

    minute_select_children = root_children[2].children.reject {|node| node.name == 'text' }
    assert_equal %w(select), minute_select_children.map(&:name)
    assert_equal "#{@object_name}__dpwt_#{@attr}_m", minute_select_children[0].attributes['id'].value

    timezone ||= 'UTC'
    timezone_span = root_children[3]
    assert_equal 'span', timezone_span.name
    assert_equal "#{@object_name}__dpwt_#{@attr}_timezone", timezone_span.attributes['id'].value
    assert_equal timezone, timezone_span.inner_html

    timezone_input = root_children[4]
    assert_equal 'input', timezone_input.name
    assert_equal "#{@object_name}__dpwt_#{@attr}_z", timezone_input.attributes['id'].value
    assert_equal 'hidden', timezone_input.attributes['type'].value
    assert_equal timezone, timezone_input.attributes['value'].value
  end
end
