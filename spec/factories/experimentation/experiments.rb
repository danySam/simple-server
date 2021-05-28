FactoryBot.define do
  factory :experiment, class: Experimentation::Experiment do
    id { SecureRandom.uuid }
    name { Faker::Lorem.unique.word }
    state { "new" }
    experiment_type { "current_patients" }
    start_date {}
    end_date {}
  end

  trait :with_treatment_group do
    treatment_groups { create_list(:treatment_group, 1) }
  end

  trait :with_treatment_group_and_template do
    treatment_groups { create_list(:treatment_group, 1, :with_template) }
  end
end
