# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
2000.times do
  applicant = Applicant.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    cell: Faker::PhoneNumber.cell_phone,
    zipcode: Faker::Address.zip.split("-")[0],
    background_consent: rand(1..10) > 2,
    created_at: Time.now - (rand(0..52).weeks),
    aasm_state: "applied"
  )
  if applicant.background_consent
    applicant.aasm_state = $APPLICANT_STATES[rand(0..5)]
  end
  applicant.save
end
