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
          method = :"_dpwt_set_#{base}"

          klass.class_eval do
            define_method attrs[0] do
              send(base)&.strftime('%Y-%m-%d')
            end

            define_method attrs[1] do
              send(base)&.strftime('%H')
            end

            define_method attrs[2] do
              send(base)&.strftime('%M')
            end

            define_method attrs[3] do
              send(base)&.strftime('%Z')
            end

            attrs.each_with_index do |a, i|
              define_method :"#{a}=" do |val|
                instance_variable_set ivars[i], val
                send(method)

                val
              end
            end

            define_method method do
              send :"#{base}=",
                ivars.any? {|v| instance_variable_get(v).blank? } ?
                  nil :
                  [
                    instance_variable_get(ivars[0]),
                    [
                      instance_variable_get(ivars[1]),
                      instance_variable_get(ivars[2])
                    ].join(':'),
                    instance_variable_get(ivars[3]),
                  ].join(' ')
            end

            private method
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
