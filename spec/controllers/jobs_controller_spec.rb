require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "returns correct response with job details" do
      job1 = create(:job)
      job2 = create(:job)

      expected_jobs_data = [
        {
          "name" => job1.title,
          "status" => job1.status,
          "number_of_hired_candidates" => job1.applications.hired.count,
          "number_of_rejected_candidates" => job1.applications.rejected.count,
          "number_of_ongoing_applications" => job1.applications.ongoing.count
        },
        {
          "name" => job2.title,
          "status" => job2.status,
          "number_of_hired_candidates" => job2.applications.hired.count,
          "number_of_rejected_candidates" => job2.applications.rejected.count,
          "number_of_ongoing_applications" => job2.applications.ongoing.count
        }
      ]

      get :index
      response_body = JSON.parse(response.body)
      expect(response_body).to eq(expected_jobs_data)
    end
  end

  describe "GET #applications_for_activated_jobs" do
    it "returns correct response with applications for activated jobs" do
      job = create(:job_activated, app_count: 3)
      application4 = create(:application, job: job, candidate_name: Faker::Name.name)
      application5 = create(:application, job: job, candidate_name: Faker::Name.name)

      create(:note_event, eventable: application4)
      create(:interview_event, eventable: application5)

      get :applications_for_activated_jobs

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      response_body = JSON.parse(response.body)
      
      expect(response_body.length).to eq(5)

      last_two_candidates = response_body.last(2)

      expect(last_two_candidates[0]["job_name"]).to eq(job.title)
      expect(last_two_candidates[0]["candidate_name"]).to eq(application4.candidate_name)
      expect(last_two_candidates[0]["application_status"]).to eq(application4.status)
      expect(last_two_candidates[0]["number_of_notes"]).to eq(1)
      expect(last_two_candidates[0]["last_interview_date"]).to be_nil

      expect(last_two_candidates[1]["job_name"]).to eq(job.title)
      expect(last_two_candidates[1]["candidate_name"]).to eq(application5.candidate_name)
      expect(last_two_candidates[1]["application_status"]).to eq(application5.status)
      expect(last_two_candidates[1]["number_of_notes"]).to eq(0)
      expect(last_two_candidates[1]["last_interview_date"]).to eq(application5.events.last.interview_date)
    end
  end
end
