class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :qb_token
      t.string :qb_secret
      t.string :qb_company_id

      t.timestamps
    end
  end
end
