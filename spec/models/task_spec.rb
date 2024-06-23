require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake! # Use fake testing mode

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task) { build(:task, user: user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:deadline) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values([:backlog, :in_progress, :done]) }
  end

  describe 'private methods' do
    context '#schedule_reminders' do
      it 'schedules two reminders unless status is done' do
        allow(task).to receive(:done?).and_return(false)
        expect(SendReminderJob).to receive(:set).twice.and_call_original
        task.send(:schedule_reminders)
      end

      it 'does not schedule reminders if task is done' do
        allow(task).to receive(:done?).and_return(true)
        expect(SendReminderJob).not_to receive(:set)
        task.send(:schedule_reminders)
      end
    end

    context '#reschedule_reminders' do
      it 'calls #schedule_reminders' do
        expect(task).to receive(:schedule_reminders)
        task.send(:reschedule_reminders)
      end
    end
  end
end
