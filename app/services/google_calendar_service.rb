require 'google/apis/calendar_v3'
require 'googleauth'
require 'google/api_client/client_secrets'
require 'googleauth/stores/file_token_store'

class GoogleCalendarService
  def initialize(user)
    @user = user
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = 'calender-api'
    @service.authorization = google_credentials_for(user)
  end

  def create_event(task)
    event = Google::Apis::CalendarV3::Event.new(
      summary: task.title,
      description: task.description,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: task.deadline.to_datetime.rfc3339,
        time_zone: 'America/Los_Angeles'
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: (task.deadline + 1.hour).to_datetime.rfc3339,
        time_zone: 'America/Los_Angeles'
      )
    )
    begin
      result = @service.insert_event('primary', event)
    rescue StandardError => e
      puts e.message
      puts e.backtrace
    end
    result&.id
  end

  def update_event(task)
    return unless task.google_calendar_event_id.present?

    event = @service.get_event('primary', task.google_calendar_event_id)
    event.summary = task.title
    event.description = task.description
    event.start.date_time = task.deadline.to_datetime.rfc3339
    event.end.date_time = (task.deadline + 1.hour).to_datetime.rfc3339

    @service.update_event('primary', event.id, event)
  end

  def delete_event(task)
    return unless task.google_calendar_event_id.present?

    @service.delete_event('primary', task.google_calendar_event_id)
  end

  private

  def google_credentials_for(user)
    client_id = Google::Auth::ClientId.from_file(Rails.root.join('config/client_secret.json'))
    token_store = Google::Auth::Stores::FileTokenStore.new(file: Rails.root.join('config/token.yaml'))
    authorizer = Google::Auth::UserAuthorizer.new(client_id, Google::Apis::CalendarV3::AUTH_CALENDAR, token_store)
    user_id = user.email # Assuming user's email is unique and serves as identifier

    authorizer.get_credentials(user_id)
  end
end
