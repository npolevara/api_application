class Job < ApplicationRecord
  has_many :applications, dependent: :destroy
  has_many :events, as: :eventable, class_name: 'Job::Event', dependent: :destroy

  def add_event(event_type)
    event_class = "Job::Event::#{event_type.camelize}".constantize
    events.create!(type: event_class.name)
  end

  class Event < ::Event
    self.table_name = 'events'
    after_create :update_job_status

    private

    def update_job_status
      if eventable.is_a?(Job)
        status = case type
        when 'Job::Event::Activated'
          'activated'
        when 'Job::Event::Deactivated'
          'deactivated'
        else
          'deactivated'
        end

        eventable.update!(status: status)
      end
    end

    class Activated < Event
    end
  
    class Deactivated < Event
    end
  end
end
