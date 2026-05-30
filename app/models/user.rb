class User < ApplicationRecord
  PASSWORD_MIN_LENGTH = 8
  BIO_MAX_LENGTH = 2_000

  has_secure_password

  has_many :articles, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :username, with: ->(username) { username.strip.downcase }

  validates :username,
    presence: true,
    length: { minimum: 3, maximum: 30 },
    uniqueness: true,
    format: { with: /\A[a-z0-9_]+\z/i, message: "só pode conter letras, números e _" }

  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
    length: { minimum: PASSWORD_MIN_LENGTH },
    if: -> { password.present? }

  validates :bio,
    length: { maximum: BIO_MAX_LENGTH },
    allow_blank: true
end
