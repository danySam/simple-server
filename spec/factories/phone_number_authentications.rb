FactoryBot.define do
  factory :phone_number_authentication do
    phone_number { Faker::PhoneNumber.phone_number }
    password { rand(1000..9999).to_s }
    password_confirmation { password }
    otp { rand(100000..999999).to_s }
    otp_valid_until { 3.minutes.from_now }
    access_token { SecureRandom.hex(32) }

    facility

    trait :with_password_digest do
      password { nil }
      password_digest { Faker::Crypto.sha256 }
    end
  end
end
