class TaskMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def reminder_email(task)
    @task = task
    mail(to: @task.user.email, subject: 'Task Deadline Reminder')
  end
end
