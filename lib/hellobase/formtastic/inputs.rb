require 'hellobase/formtastic/inputs/content_input'
require 'hellobase/formtastic/inputs/datepicker_with_time_input'
require 'hellobase/formtastic/inputs/inline_checkbox_input'
require 'hellobase/formtastic/inputs/time_of_day_input'

module Hellobase
  module Formtastic
    module Inputs
    end
  end
end

::Hellobase::Formtastic::Inputs.constants.each do |c|
  Object.const_set c, ::Hellobase::Formtastic::Inputs.const_get(c)
end
