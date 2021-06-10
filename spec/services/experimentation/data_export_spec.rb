require "rails_helper"

RSpec.describe Experimentation::DataExport, type: :model do
  describe "#result" do
    it "raises an error when experiment is not found" do
      expect{
        described_class.new("fake")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context "when experiment is found" do
      before :each do
        @experiment = create(:experiment, start_date: 2.weeks.ago, end_date: 1.week.ago)
        @treatment_group1 = create(:treatment_group, experiment: @experiment, description: "Has reminder templates")
        @treatment_group2 = create(:treatment_group, experiment: @experiment, description: "Control")
        @reminder_template1 = create(:reminder_template, treatment_group: @treatment_group1, remind_on_in_days: -3)
        @reminder_template2 = create(:reminder_template, treatment_group: @treatment_group1, remind_on_in_days: 0)
        @reminder_template3 = create(:reminder_template, treatment_group: @treatment_group1, remind_on_in_days: 3)
        @patient1 = create(:patient)
        @patient2 = create(:patient)
        Timecop.freeze(2.weeks.ago) do
          @treatment_group1.patients << @patient1
          @treatment_group2.patients << @patient2
        end
        create(:encounter, encountered_on: 1.week.ago, patient: @patient1)
        create(:encounter, encountered_on: 1.day.ago, patient: @patient1)
      end


      it "includes one row per patient" do
        exporter = described_class.new(@experiment.name)
        results = exporter.result
        puts results
        expect(results.length).to eq(2)
      end
    end
  end
end