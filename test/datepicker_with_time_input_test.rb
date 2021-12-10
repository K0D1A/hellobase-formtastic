require 'test_helper'

class DatepickerWithTimeInputTest < Minitest::Test
  def test_to_html
    tag = Hellobase::Formtastic::Inputs::DatepickerWithTimeInput.new(@builder, @template, @object, @object_name, @attr, {}).to_html
    root = parse_and_check_root(tag)
    root_children = root.children.reject {|node| node.name == 'text' }
    assert_equal ['span'] * 3, root_children.map(&:name) # wrappers
    check_inputs(root_children)
  end

  def test_time_zone_option
    zone = 'America/Los_Angeles'
    tag = Hellobase::Formtastic::Inputs::DatepickerWithTimeInput.new(@builder, @template, @object, @object_name, @attr, time_zone: zone).to_html
    root = parse_and_check_root(tag)
    root_children = root.children.reject {|node| node.name == 'text' }
    assert_equal ['span'] * 4, root_children.map(&:name) # wrappers
    check_inputs(root_children, zone: zone)
  end

  private

  def setup
    super

    @attr = :datetime
    unless @object.respond_to?(Hellobase::Formtastic::Inputs::DatepickerWithTimeInput.virtual_attributes(@attr).first)
      Hellobase::Formtastic::Inputs::DatepickerWithTimeInput.define_virtual_attributes @object.class, @attr
    end
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

  def check_inputs(root_children, **options)
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

    if zone = options[:zone]
      assert_equal zone, root_children[3].inner_html # zone_display_html
    else
      assert root_children[3].nil?
    end
  end
end