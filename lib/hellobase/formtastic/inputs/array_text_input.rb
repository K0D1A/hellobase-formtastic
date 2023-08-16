require 'active_admin/inputs'

module Hellobase
  module Formtastic
    module Inputs
      class ArrayTextInput < ::Formtastic::Inputs::TextInput
        def self.virtual_attributes(base)
          [:"_stra_#{base}_text"]
        end

        def self.define_virtual_attributes(klass, base)
          vattr = virtual_attributes(base).first
          ivar = :"@#{vattr}"
          method = :"_stra_set_#{base}"

          klass.class_eval do
            define_method vattr do
              send(base)&.join("\n")
            end

            define_method :"#{vattr}=" do |val|
              instance_variable_set ivar, val
              send(method)

              val
            end

            define_method method do
              send :"#{base}=", instance_variable_get(ivar)&.split(/[\r\n]+/)
            end

            private method
          end
        end

        def to_html
          input_wrapping do
            label_html <<
            builder.text_area(:"_stra_#{method}_text", input_html_options)
          end
        end
      end
    end
  end
end
