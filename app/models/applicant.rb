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

  $APPLICANT_STATES = ["applied", "quiz_started", "quiz_completed", "onboarding_requested", "hired", "rejected"]

  def self.retrieve_weekly_stats(start_date, end_date)
    # retrieve the named functions based on what DB we are using
    week_field, start_week, end_week = named_functions

    results = Applicant.where("created_at BETWEEN ? AND ?", start_date, end_date).group(week_field, "aasm_state").order(week_field + " DESC").pluck(start_week, end_week, "aasm_state", "count(id)")

    formatted = {}
    results.each do |res|
      bucket = formatted["#{res[0]}-#{res[1]}"] ||= {}
      bucket[res[2]] = res[3]
    end
    formatted
  end

  def self.retrieve_admin_stats(start_date, end_date)
    collection = []
    retrieve_weekly_stats(start_date, end_date).each do |k,v|
      v['week_start'] = k[0..9]
      v['week_end'] = k[11..20]
      collection << v
    end
    collection
  end

  private

  def self.named_functions
    # Have to use different named functions for postgresql and sqlite3..
    # ** NOTE: This will only work for sqlite and postgres O_O
    if ActiveRecord::Base.connection_config[:adapter] == "sqlite3"
      ["strftime('%W', created_at)", "date(created_at, 'weekday 0', '-6 day')", "date(created_at, 'weekday 0', '0 day')"]
    else
      ["date_trunc('week', created_at)::date", "date_trunc('week', created_at)::date", "(date_trunc('week', created_at)::date + '6 days'::interval)::date"]
    end
  end
end
