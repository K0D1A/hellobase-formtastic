require 'active_admin/inputs'

module Hellobase
  module Formtastic
    module Inputs
      class DatepickerWithTimeInput
        include ::Formtastic::Inputs::Base

        def self.virtual_attributes(base)
          [:"_dpwt_#{base}_d", :"_dpwt_#{base}_h", :"_dpwt_#{base}_m", :"_dpwt_#{base}_z"]
        end

        def self.define_virtual_attributes(klass, base)
          attrs = virtual_attributes(base)
          ivars = attrs.map {|a| :"@#{a}" }
          recalc_method = :"_dpwt_recalc_#{base}"

          klass.class_eval do
            define_method attrs[0] do
              if instance_variable_defined? ivars[0]
                instance_variable_get ivars[0]
              else
                instance_variable_set ivars[0], send(base)&.strftime('%Y-%m-%d')
              end
            end

            define_method attrs[1] do
              if instance_variable_defined? ivars[1]
                instance_variable_get ivars[1]
              else
                instance_variable_set ivars[1], send(base)&.strftime('%H')
              end
            end

            define_method attrs[2] do
              if instance_variable_defined? ivars[2]
                instance_variable_get ivars[2]
              else
                instance_variable_set ivars[2], send(base)&.strftime('%M')
              end
            end

            define_method attrs[3] do
              if instance_variable_defined? ivars[3]
                instance_variable_get ivars[3]
              else
                instance_variable_set ivars[3], send(base)&.zone
              end
            end

            attrs.each_with_index do |a, i|
              define_method :"#{a}=" do |val|
                instance_variable_set ivars[i], val
                send recalc_method
              end
            end

            define_method recalc_method do
              val = if attrs.any? {|attr| send(attr).blank? }
                nil
              else
                begin
                  Time.use_zone(send(attrs[3])) do
                    Time.zone.parse("#{send(attrs[0])} #{send(attrs[1])}:#{send(attrs[2])}")
                  end
                rescue ArgumentError
                  nil
                end
              end

              send :"#{base}=", val
            end

            private recalc_method
          end
        end

        def to_html
          datepicker_html = ::ActiveAdmin::Inputs::DatepickerInput.new(builder, template, object, object_name, :"_dpwt_#{method}_d", datepicker_options).to_html
          hour_select_html = ::Formtastic::Inputs::SelectInput.new(builder, template, object, object_name, :"_dpwt_#{method}_h", hour_select_options).to_html
          minute_select_html = ::Formtastic::Inputs::SelectInput.new(builder, template, object, object_name, :"_dpwt_#{method}_m", minute_select_options).to_html

          timezone = options[:timezone] || 'UTC'
          timezone_span_html = template.content_tag(:span, timezone, id: "#{object_name}__dpwt_#{method}_timezone")
          timezone_hidden_input_html = template.hidden_field_tag("#{object_name}[_dpwt_#{method}_z]", timezone, :id => "#{object_name}__dpwt_#{method}_z")

          wrapper_contents = [
            replace_li_tag(datepicker_html),
            replace_li_tag(hour_select_html),
            replace_li_tag(minute_select_html),
            timezone_span_html,
            timezone_hidden_input_html,
            error_html,
            hint_html,
          ].compact.join("\n").html_safe

          template.content_tag(:li, wrapper_contents, wrapper_html_options)
        end

        private

        def datepicker_options
          {
            label: label_text,
          }.merge(options[:datepicker_options] || {})
        end

        def hour_select_options
          {
            label: false,
            collection: (0..23).map {|i| '%02i' % i },
          }.merge(options[:hour_select_options] || {})
        end

        def minute_select_options
          {
            label: false,
            collection: (0..59).map {|i| '%02i' % i },
          }.merge(options[:minute_select_options] || {})
        end

        # formtastic inputs generate <li> with no way to override
        def replace_li_tag(html)
          html.strip.sub(/^<li /, '<span ').sub(/<\/li>$/, '</span>').html_safe
        end
      end
    end
  end
end
