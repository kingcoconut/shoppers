class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :cell
      t.string :zipcode
      t.string :aasm_state, default: "applied"
      t.boolean :background_consent

      t.timestamps null: false
    end
  end
end
