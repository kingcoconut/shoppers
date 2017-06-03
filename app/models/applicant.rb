class Applicant < ActiveRecord::Base
  has_one :linkedin_account
  # this will all be valiated on the frontend but replicated here for consistency
  # and to help prevent abusive script attacks
  validates_presence_of :first_name, :last_name, :email, :zipcode, :cell
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, message: "should be a valid email address"
  validates_format_of :zipcode, with: /\A\d{5}(-\d{4})?\z/, message: "should be in the form 12345 or 12345-1234"
  phony_normalize :cell, default_country_code: 'US'
  validates :cell, phony_plausible: true
end
