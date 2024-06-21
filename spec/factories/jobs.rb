FactoryBot.define do
  factory :job do
    title { Faker::Job.title }

    transient do
      app_count { 5 }
    end

    after(:create) do |job, evaluator|
      create_list(:application, evaluator.app_count, job: job)
    end

    factory :job_activated do
      title { Faker::Job.title }
      status { "activated" }
    end
  end
end
