class CreateMaintainerships < ActiveRecord::Migration[6.1]
  def change
    create_table :maintainerships do |t|
      t.references :package, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
