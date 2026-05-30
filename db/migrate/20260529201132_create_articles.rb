class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.boolean :published
      t.integer :popularity
      t.string :ref
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
