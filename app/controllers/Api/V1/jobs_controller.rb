class Api::V1::JobsController < ApplicationController
  def index
    jobs = Job.all.includes(:applications, :events)

    jobs_data = jobs.map do |job|
      {
        name: job.title,
        status: job.status,
        number_of_hired_candidates: job.applications.hired.count,
        number_of_rejected_candidates: job.applications.rejected.count,
        number_of_ongoing_applications: job.applications.ongoing.count
      }
    end
    render json: jobs_data
  end

  def applications_for_activated_jobs
    activated_jobs = Job.includes(applications: [:events]).select { |job| job.status == 'activated' }

    result = activated_jobs.flat_map do |job|
      job.applications.map do |application|
        {
          job_name: application.job.title,
          candidate_name: application.candidate_name,
          application_status: application.status,
          number_of_notes: application.events.where(type: 'Application::Event::Note').count,
          last_interview_date: last_interview_date(application)
        }
      end
    end

    render json: result
  end

  private

  def last_interview_date(application)
    last_interview_event = application.events.where(type: 'Application::Event::Interview').order(created_at: :desc).first
    last_interview_event&.event_data&.[]('interview_date')
  end
end
