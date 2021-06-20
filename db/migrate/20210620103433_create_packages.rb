class CreatePackages < ActiveRecord::Migration[6.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :title
      t.text :description

      t.timestamps
    end

    add_index :packages, :name, unique: true
  end
end
