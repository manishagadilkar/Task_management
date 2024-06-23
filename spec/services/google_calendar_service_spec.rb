require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GoogleCalendarService, type: :service do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:task) { create(:task, title: 'Test Task', description: 'Test Description', deadline: Time.now + 1.day, user: user, google_calendar_event_id: 'test_event_id') }
  let(:service) { GoogleCalendarService.new(user) }

  before do
    allow(service).to receive(:google_credentials_for).and_return(double(:credentials))
  end

  describe '#create_event' do
    it 'creates a calendar event' do
      stub_request(:post, 'https://www.googleapis.com/calendar/v3/calendars/primary/events')
        .to_return(status: 200, body: { id: 'event_id' }.to_json, headers: { 'Content-Type' => 'application/json' })

      event_id = service.create_event(task)

      expect(event_id).to eq('event_id')
    end
  end

  describe '#update_event' do
    it 'updates the calendar event' do
      stub_request(:get, "https://www.googleapis.com/calendar/v3/calendars/primary/events/#{task.google_calendar_event_id}")
        .to_return(status: 200, body: {
            id: 'event_id',
            summary: 'Old Summary',
            description: 'Old Description',
            start: { dateTime: (task.deadline - 1.hour).to_datetime.rfc3339 },
            end: { dateTime: task.deadline.to_datetime.rfc3339 } 
          }.to_json, headers: { 'Content-Type' => 'application/json' })
        
      stub_request(:put, "https://www.googleapis.com/calendar/v3/calendars/primary/events/event_id")
        .to_return(status: 200, body: {}.to_json, headers: { 'Content-Type' => 'application/json' })

      expect { service.update_event(task) }.not_to raise_error
    end
  end

  describe '#delete_event' do
    it 'deletes the calendar event' do
      stub_request(:delete, "https://www.googleapis.com/calendar/v3/calendars/primary/events/#{task.google_calendar_event_id}")
        .to_return(status: 204, body: '', headers: { 'Content-Type' => 'application/json' })

      expect { service.delete_event(task) }.not_to raise_error
    end
  end
end
