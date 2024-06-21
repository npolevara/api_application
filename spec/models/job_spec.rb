require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { should have_many(:applications).dependent(:destroy) }
    it { should have_many(:events).dependent(:destroy) }
  end

  describe '#add_event' do
    let(:job) { create(:job) }

    it 'creates an activated event' do
      expect { job.add_event('activated') }.to change { job.events.count }.by(1)

      event = job.events.last
      expect(event).to be_a(Job::Event::Activated)
    end

    it 'creates a deactivated event' do
      expect { job.add_event('deactivated') }.to change { job.events.count }.by(1)

      event = job.events.last
      expect(event).to be_a(Job::Event::Deactivated)
    end
  end
end
