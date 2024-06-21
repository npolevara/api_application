FactoryBot.define do
  factory :activated_event, class: 'Job::Event::Activated' do
    association :eventable, factory: :job
  end

  factory :deactivated_event, class: 'Job::Event::Deactivated' do
    association :eventable, factory: :job
  end

  factory :interview_event, class: 'Application::Event::Interview' do
    association :eventable, factory: :application
    event_data { { interview_date: 1.day.from_now } }
  end

  factory :hired_event, class: 'Application::Event::Hired' do
    association :eventable, factory: :application
    event_data { { hire_date: Date.today } }
  end

  factory :rejected_event, class: 'Application::Event::Rejected' do
    association :eventable, factory: :application
  end

  factory :note_event, class: 'Application::Event::Note' do
    association :eventable, factory: :application
    event_data { { content: Faker::Job.title } }
  end
end
