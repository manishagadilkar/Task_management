FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :with_omniauth do
      transient do
        provider { 'google_oauth2' }
        uid { SecureRandom.hex(10) }
      end

      after(:create) do |user, evaluator|
        user.update(
          provider: evaluator.provider,
          uid: evaluator.uid
        )
      end
    end
  end

  factory :task do
    association :user
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { :backlog }
    deadline { Faker::Time.forward(days: 10, period: :morning) }

    trait :in_progress do
      status { :in_progress }
    end

    trait :done do
      status { :done }
    end

    after(:create) do |task|
      # Optionally you can handle callbacks here if needed.
    end
  end
end
