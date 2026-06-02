class ArticleCommentVote < ApplicationRecord
  belongs_to :article_comment
  belongs_to :user

  validates :vote, inclusion: { in: [ true, false ] }

  validates :user_id,
    uniqueness: { scope: :article_comment_id }
end
