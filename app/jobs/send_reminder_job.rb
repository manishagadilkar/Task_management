class SendReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)
    return unless task.deadline > Time.current && !task.done?

    TaskMailer.reminder_email(task).deliver_later
  end
end
