require 'rails_helper'

RSpec.describe LinkedinAccount, :type => :model do
  context "associations" do
    it { is_expected.to belong_to :applicant }
  end

  context "validations" do
    it { is_expected.to validate_presence_of :applicant_id }
    it { is_expected.to validate_uniqueness_of :applicant_id }
  end
end
