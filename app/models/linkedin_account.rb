class LinkedinAccount < ActiveRecord::Base
  belongs_to :applicant
  validates :applicant_id, presence: true, uniqueness: true
end
