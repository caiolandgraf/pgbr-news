class ArticleVote < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :vote, inclusion: { in: [ true, false ] }

  validates :user_id,
    uniqueness: { scope: :article_id }
end
