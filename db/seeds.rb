Job.destroy_all

jobs = []
5.times do
  jobs << Job.create!(
    title: Faker::Job.title,
    description: Faker::Lorem.paragraph
  )
end

jobs.each do |job|
  job_event_type = ["Job::Event::Activated", "Job::Event::Deactivated"].sample
  job.events.create!(
    type: job_event_type,
    event_data: {}
  )
  
  5.times do
    application = Application.create!(
      job: job,
      candidate_name: Faker::Name.name
    )

    app_event_types = ["Interview", "Hired", "Rejected", "Note"]
    app_event_type = app_event_types.sample

    case app_event_type
    when "Interview"
      application.events.create!(
        type: "Application::Event::Interview",
        event_data: { interview_date: Faker::Date.backward(days: 10) }
      )
    when "Hired"
      application.events.create!(
        type: "Application::Event::Hired",
        event_data: { hire_date: Faker::Date.backward(days: 10) }
      )
    when "Rejected"
      application.events.create!(
        type: "Application::Event::Rejected",
        event_data: {}
      )
    when "Note"
      application.events.create!(
        type: "Application::Event::Note",
        event_data: { content: Faker::Lorem.sentence }
      )
    end
  end
end

counts = {
  "Jobs" => Job.count,
  "Job::Event::Activated" => Job::Event::Activated.count,
  "Job::Event::Deactivated" => Job::Event::Deactivated.count,
  "Applications" => Application.count,
  "Application::Event::Interview" => Application::Event::Interview.count,
  "Application::Event::Hired" => Application::Event::Hired.count,
  "Application::Event::Rejected" => Application::Event::Rejected.count,
  "Application::Event::Note" => Application::Event::Note.count
}

counts.each do |name, count|
  puts "#{name}: #{count}"
end
