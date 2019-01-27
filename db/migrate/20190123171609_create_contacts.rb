class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.column :user_id, 'bigint unsigned'
      t.string :name, null: false
      t.string :email, null: false
      t.timestamps null: false
    end
  end
end
