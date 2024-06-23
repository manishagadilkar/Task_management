class Task < ApplicationRecord
  belongs_to :user

  enum status: { backlog: 0, in_progress: 1, done: 2 }

  validates :title, :description, :status, :deadline, presence: true
  after_create :schedule_reminders
  after_update :reschedule_reminders, if: :saved_change_to_deadline?

  private

  def schedule_reminders
    return if done?

    reminder_1_day_before = deadline - 1.day
    reminder_1_hour_before = deadline - 1.hour

    SendReminderJob.set(wait_until: reminder_1_day_before).perform_later(id)
    SendReminderJob.set(wait_until: reminder_1_hour_before).perform_later(id)
  end

  def reschedule_reminders
    # Remove old scheduled jobs and reschedule new ones
    schedule_reminders
  end
end
