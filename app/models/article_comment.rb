class ArticleComment < ApplicationRecord
  BODY_MIN_LENGTH = 3
  BODY_MAX_LENGTH = 20_000

  belongs_to :article
  belongs_to :user
  belongs_to :parent,
    class_name: "ArticleComment",
    optional: true

  has_many :children,
    class_name: "ArticleComment",
    foreign_key: :parent_id,
    dependent: :destroy

  has_many :article_comment_votes, dependent: :destroy

  scope :roots, -> { where(parent_id: nil) }
  scope :active, -> { where(deleted_at: nil) }

  validates :body,
    presence: true,
    length: { minimum: BODY_MIN_LENGTH, maximum: BODY_MAX_LENGTH }

  validates :popularity, presence: true
  validates :depth, presence: true
  validates :children_count, presence: true

  def deleted?
    deleted_at.present?
  end

  def vote(direction, user)
    new_vote = direction == :up

    article_comment_vote = ArticleCommentVote.find_or_initialize_by(article_comment: self, user: user)

    previous_vote = article_comment_vote.vote

    transaction do
      if previous_vote.nil?
        self.popularity += new_vote ? 1 : -1
        article_comment_vote.vote = new_vote
        article_comment_vote.save!
      elsif previous_vote == new_vote
        # repeating the same vote -> cancel the vote
        self.popularity += new_vote ? -1 : 1
        article_comment_vote.destroy!
      elsif previous_vote
        # upvote -> downvote
        self.popularity -= 2
        article_comment_vote.vote = new_vote
        article_comment_vote.save!
      else
        # downvote -> upvote
        self.popularity += 2
        article_comment_vote.vote = new_vote
        article_comment_vote.save!
      end

      save!
    end

    true
  end
end
