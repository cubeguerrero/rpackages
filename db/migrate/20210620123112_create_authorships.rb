class CreateAuthorships < ActiveRecord::Migration[6.1]
  def change
    create_table :authorships do |t|
      t.references :person, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true

      t.timestamps
    end
  end
end
