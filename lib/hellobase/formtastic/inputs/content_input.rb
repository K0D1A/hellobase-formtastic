module Hellobase
  module Formtastic
    module Inputs
      class ContentInput < ::Formtastic::Inputs::StringInput
        def to_html
          input_wrapping do
            label_html <<
              template.content_tag(:span, options[:content])
          end
        end
      end
    end
  end
end
