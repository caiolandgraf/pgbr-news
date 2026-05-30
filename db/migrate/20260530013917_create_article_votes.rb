class CreateArticleVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :article_votes do |t|
      t.references :article, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.boolean :vote, null: false

      t.timestamps
    end

    add_index :article_votes,
      [ :article_id, :user_id ],
      unique: true
  end
end
