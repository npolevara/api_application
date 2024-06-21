class Event < ApplicationRecord
  self.abstract_class = true
  belongs_to :eventable, polymorphic: true

  serialize :event_data, JSON
end
