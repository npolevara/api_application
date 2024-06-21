require 'rails_helper'

RSpec.describe Job::Event, type: :model do
  describe 'job callbacks' do
    let(:job) { create(:job) }

    context 'when an activated event is created' do
      it 'updates the job status to activated' do
        expect { create(:activated_event, eventable: job) }.to change { job.reload.status }.from('deactivated').to('activated')
      end
    end

    context 'when a deactivated event is created' do
      it 'updates the job status to deactivated' do
        job.update!(status: 'activated')
        expect { create(:deactivated_event, eventable: job) }.to change { job.reload.status }.from('activated').to('deactivated')
      end
    end
  end

  describe 'application callbacks' do
    let(:application) { create(:application) }

    context 'when an interview event is created' do
      it 'updates the application status to interview' do
        expect {
          create(:interview_event, eventable: application)
        }.to change { application.reload.status }.from('applied').to('interview')
      end
    end

    context 'when a hired event is created' do
      it 'updates the application status to hired' do
        expect {
          create(:hired_event, eventable: application)
        }.to change { application.reload.status }.from('applied').to('hired')
      end
    end

    context 'when a rejected event is created' do
      it 'updates the application status to rejected' do
        expect {
          create(:rejected_event, eventable: application)
        }.to change { application.reload.status }.from('applied').to('rejected')
      end
    end
  end
end
