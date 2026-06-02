class CreateArticleComments < ActiveRecord::Migration[8.1]
  def change
    create_table :article_comments do |t|
      t.references :article, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :article_comments }

      t.text :body, null: false
      t.integer :popularity, default: 0, null: false
      t.integer :depth, null: false, default: 0
      t.integer :children_count, null: false, default: 0
      t.timestamps
    end
  end
end
