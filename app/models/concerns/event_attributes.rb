module EventAttributes
  extend ActiveSupport::Concern

  class_methods do
    def define_event_attribute(attr_name)
      define_method(attr_name) do
        event_data[attr_name.to_s]
      end

      define_method("#{attr_name}=") do |value|
        self.event_data ||= {}
        self.event_data[attr_name.to_s] = value
      end
    end
  end
end
