require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'associations' do
    it { should belong_to(:job) }
    it { should have_many(:events).dependent(:destroy) }
  end

  describe 'scopes' do
    let!(:hired_application) { create(:application, status: 'hired') }
    let!(:rejected_application) { create(:application, status: 'rejected') }
    let!(:ongoing_application) { create(:application, status: 'interview') }

    it 'returns hired applications' do
      expect(Application.hired).to include(hired_application)
      expect(Application.hired).not_to include(rejected_application)
      expect(Application.hired).not_to include(ongoing_application)
    end

    it 'returns rejected applications' do
      expect(Application.rejected).to include(rejected_application)
      expect(Application.rejected).not_to include(hired_application)
      expect(Application.rejected).not_to include(ongoing_application)
    end

    it 'returns ongoing applications' do
      expect(Application.ongoing).to include(ongoing_application)
      expect(Application.ongoing).not_to include(hired_application)
      expect(Application.ongoing).not_to include(rejected_application)
    end
  end

  describe '#add_event' do
    let(:application) { create(:application) }

    it 'creates an interview event' do
      expect {
        application.add_event('interview', { interview_date: "20/06/2024" })
      }.to change { application.events.count }.by(1)

      event = application.events.last
      expect(event).to be_a(Application::Event::Interview)
      expect(event.event_data['interview_date']).to eq("20/06/2024")
    end

    it 'creates a hired event' do
      expect {
        application.add_event('hired', { hire_date: "20/06/2024" })
      }.to change { application.events.count }.by(1)

      event = application.events.last
      expect(event).to be_a(Application::Event::Hired)
      expect(event.event_data['hire_date']).to eq("20/06/2024")
    end

    it 'creates a rejected event' do
      expect {
        application.add_event('rejected', {})
      }.to change { application.events.count }.by(1)

      event = application.events.last
      expect(event).to be_a(Application::Event::Rejected)
    end
  end

  describe '#add_note' do
    let(:application) { create(:application) }

    it 'creates a note event' do
      expect {
        application.add_note("This is a note")
      }.to change { application.events.count }.by(1)

      event = application.events.last
      expect(event).to be_a(Application::Event::Note)
      expect(event.event_data['content']).to eq("This is a note")
    end
  end
end
