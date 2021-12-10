module Hellobase
  module Formtastic
    module Inputs
      class TimeOfDayInput < ::Formtastic::Inputs::SelectInput
        def initialize(*)
          super

          @options[:collection] ||= build_times_collection
        end

        private

        def build_times_collection
          hours = 0..23
          minutes = (0..59).select {|m| m % 5 == 0 }
          seconds = (0..59).select {|m| m % 60 == 0 }
          times = hours.map {|h| minutes.map {|m| seconds.map {|s| Tod::TimeOfDay.new(h, m, s) } } }.flatten

          format = '%I:%M %p'
          times.map {|t| [t.strftime(format), t.to_s] }
        end
      end
    end
  end
end
