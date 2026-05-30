class AddDefaultToArticlePopularity < ActiveRecord::Migration[8.1]
  def change
    change_column_default :articles, :popularity, from: nil, to: 0
  end
end
