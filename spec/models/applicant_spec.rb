require 'rails_helper'

RSpec.describe Applicant, :type => :model do
  context "validations" do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
    it { is_expected.to validate_presence_of :cell }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :zipcode }
    it { is_expected.to validate_uniqueness_of :email }

    it "validates format of email address" do
      applicant = FactoryGirl.build(:applicant)
      applicant.email = "foo"
      expect(applicant.valid?).to be_falsey

      applicant.email = "foo@sss"
      expect(applicant.valid?).to be_falsey

      applicant.email = "foo@foo.bar"
      expect(applicant.valid?).to be_truthy
    end

    it "validates US cell phone" do
      applicant = FactoryGirl.build(:applicant)
      applicant.cell = "123"
      expect(applicant.valid?).to be_falsey

      applicant.cell = "1231231234"
      expect(applicant.valid?).to be_falsey

      applicant.cell = "6506861766"
      expect(applicant.valid?).to be_truthy
    end
    it "validates zipcode" do
      applicant = FactoryGirl.build(:applicant)
      applicant.zipcode = "1234"
      expect(applicant.valid?).to be_falsey

      applicant.zipcode = "12345"
      expect(applicant.valid?).to be_truthy

      applicant.zipcode = "12345-1234"
      expect(applicant.valid?).to be_truthy
    end
  end
end
