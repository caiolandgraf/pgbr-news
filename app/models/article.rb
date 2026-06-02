class Article < ApplicationRecord
  include Sluggable

  BODY_MIN_LENGTH = 100
  BODY_MAX_LENGTH = 20_000

  belongs_to :user

  has_many :article_votes, dependent: :destroy
  has_many :article_comments, dependent: :destroy

  validates :title,
    presence: true,
    length: { minimum: 3, maximum: 100 },
    uniqueness: { scope: :user_id }

  validates :slug,
    presence: true,
    length: { minimum: 3, maximum: 100 },
    uniqueness: { scope: :user_id }

  validates :body,
    presence: true,
    length: { minimum: BODY_MIN_LENGTH, maximum: BODY_MAX_LENGTH }

  validates :popularity, presence: true

  validates :ref,
    format: {
      with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
      allow_blank: true
    }

  def vote(direction, user)
    new_vote = direction == :up

    # Load existing vote (if any)
    article_vote = article_votes.find_by(user: user)
    previous_vote = article_vote&.vote

    begin
      transaction do
        if article_vote.nil?
          # first time vote
          self.popularity += new_vote ? 1 : -1
          article_votes.create!(user: user, vote: new_vote)
        elsif previous_vote == new_vote
          # repeating the same vote -> cancel the vote
          self.popularity += new_vote ? -1 : 1
          article_vote.destroy!
        else
          # switching vote
          if previous_vote
            # upvote -> downvote
            self.popularity -= 2
          else
            # downvote -> upvote
            self.popularity += 2
          end

          article_vote.update!(vote: new_vote)
        end

        save!
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Article#vote failed: #{e.message}")
      Rails.logger.error(e.record.errors.full_messages.join("; ")) if e.respond_to?(:record)
      return false
    end

    true
  end
end
