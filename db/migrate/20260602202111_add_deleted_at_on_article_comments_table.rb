class AddDeletedAtOnArticleCommentsTable < ActiveRecord::Migration[8.1]
  def change
    add_column :article_comments, :deleted_at, :datetime
    add_index :article_comments, :deleted_at
  end
end
