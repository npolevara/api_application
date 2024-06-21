FactoryBot.define do
  factory :application do
    job
    candidate_name {  Faker::Name.name }
    status { "applied" }

    transient do
      notes_count { 0 }
    end

    after(:create) do |application, evaluator|
      create_list(:application_event_note, evaluator.notes_count, eventable: application)
    end
  end
end
