class CreateVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :versions do |t|
      t.string :value
      t.datetime :published_at
      t.references :package

      t.timestamps
    end

    add_index :versions, [:value, :package_id], unique: true
  end
end
