class Application < ApplicationRecord
  belongs_to :job
  has_many :events, as: :eventable, class_name: 'Application::Event', dependent: :destroy

  scope :hired, -> { where(status: 'hired') }
  scope :rejected, -> { where(status: 'rejected') }
  scope :ongoing, -> { where.not(status: ['hired', 'rejected']) }

  def add_event(event_type, data)
    event_class = "Application::Event::#{event_type.camelize}".constantize
    events.create!(type: event_class.name, event_data: data)
  end

  def add_note(content)
    events.create!(type: 'Application::Event::Note', event_data: { content: content })
  end

  class Event < ::Event
    self.table_name = 'events'
    include EventAttributes

    after_create :update_application_status

    private

    def update_application_status
      if eventable.is_a?(Application)
        status = case type
        when 'Application::Event::Interview'
          'interview'
        when 'Application::Event::Hired'
          'hired'
        when 'Application::Event::Rejected'
          'rejected'
        else
          'applied'
        end

        eventable.update!(status: status)
      end
    end

    class Interview < Event
      define_event_attribute :interview_date
    end
  
    class Hired < Event
      define_event_attribute :hire_date
    end
  
    class Rejected < Event
    end
  
    class Note < Event
      define_event_attribute :content
    end
  end
end
