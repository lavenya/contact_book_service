class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.column :user_id, 'bigint unsigned'
      t.string :name
      t.string :phone
      t.string :email
      t.timestamps null: false
    end
  end
end
