class CreateArticleCommentVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :article_comment_votes do |t|
      t.references :article_comment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.boolean :vote, null: false

      t.timestamps
    end

    add_index :article_comment_votes,
      [ :article_comment_id, :user_id ],
      unique: true
  end
end
