class CreateLinkedinAccounts < ActiveRecord::Migration
  def change
    create_table :linkedin_accounts do |t|
      t.references :applicant, foreign_key: true
      t.string :linkedin_id
      t.string :first_name
      t.string :last_name
      t.string :num_connections
      t.string :industry
      t.string :location
      t.string :public_profile_url
      t.string :picture_url

      t.timestamps null: false
    end
  end
end
