class Article < ApplicationRecord
  include Sluggable

  BODY_MIN_LENGTH = 100
  BODY_MAX_LENGTH = 20_000

  belongs_to :user

  has_many :article_votes, dependent: :destroy

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

    article_vote = article_votes.find_or_initialize_by(user: user)

    previous_vote = article_vote.vote

    # Impede voto repetido
    return false if previous_vote == new_vote

    transaction do
      if previous_vote.nil?
        self.popularity += new_vote ? 1 : -1
      elsif previous_vote
        # upvote -> downvote
        self.popularity -= 2
      else
        # downvote -> upvote
        self.popularity += 2
      end

      article_vote.vote = new_vote

      save!
      article_vote.save!
    end

    true
  end
end
