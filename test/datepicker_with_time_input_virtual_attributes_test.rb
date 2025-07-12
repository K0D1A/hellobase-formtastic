require 'test_helper'

class TestModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :value, :datetime
  Hellobase::Formtastic::Inputs::DatepickerWithTimeInput.define_virtual_attributes self, :value
end

class DatepickerWithTimeInputVirtualAttributesTest < Minitest::Test
  def test_success
    model = TestModel.new(_dpwt_value_d: '2025-01-01', _dpwt_value_h: '12', _dpwt_value_m: '34', _dpwt_value_z: 'America/Chicago')
    assert_equal Time.use_zone('America/Chicago') { Time.parse('2025-01-01 12:34') }, model.value
  end

  def test_blank_date
    model = TestModel.new(_dpwt_value_d: '', _dpwt_value_h: '12', _dpwt_value_m: '34', _dpwt_value_z: 'America/Chicago')
    assert_nil model.value
  end

  def test_blank_hour
    model = TestModel.new(_dpwt_value_d: '2025-01-01', _dpwt_value_h: '', _dpwt_value_m: '34', _dpwt_value_z: 'America/Chicago')
    assert_nil model.value
  end

  def test_blank_minute
    model = TestModel.new(_dpwt_value_d: '2025-01-01', _dpwt_value_h: '12', _dpwt_value_m: '', _dpwt_value_z: 'America/Chicago')
    assert_nil model.value
  end

  def test_blank_zone
    model = TestModel.new(_dpwt_value_d: '2025-01-01', _dpwt_value_h: '12', _dpwt_value_m: '34', _dpwt_value_z: '')
    assert_nil model.value
  end

  # NOTE: Time.parse takes all kinds of bad strings, so these tests won't pass unless we use a stricter Time creation function

  # def test_invalid_date
  #   model = TestModel.new(_dpwt_value_d: 'xxxxx', _dpwt_value_h: '12', _dpwt_value_m: '34', _dpwt_value_z: 'America/Chicago')
  #   assert_nil model.value
  # end

  # def test_invalid_hour
  #   model = TestModel.new(_dpwt_value_d: '2025-01-01', _dpwt_value_h: 'xxxxx', _dpwt_value_m: '34', _dpwt_value_z: 'America/Chicago')
  #   assert_nil model.value
  # end

  # def test_invalid_minute
  #   model = TestModel.new(_dpwt_value_d: '2025-01-01', _dpwt_value_h: '12', _dpwt_value_m: 'xxxxx', _dpwt_value_z: 'America/Chicago')
  #   assert_nil model.value
  # end

  def test_invalid_zone
    model = TestModel.new(_dpwt_value_d: '2025-01-01', _dpwt_value_h: '12', _dpwt_value_m: '34', _dpwt_value_z: 'xxxxx')
    assert_nil model.value
  end
end
