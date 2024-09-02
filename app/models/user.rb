class User < ApplicationRecord
  has_many :explorations, dependent: :destroy
  
  validates :fullname, :password, presence: true
  validates :email, presence: true, uniqueness: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.from_google_payload(payload)
    where(email: payload['email']).first_or_create { |user|
      user.google_id = payload['sub']
      user.fullname = payload['given_name']
      user.email = payload['email']
      user.picture = payload['picture']
      user.city = ""
      user.bio = "my bio"
      user.password = Devise.friendly_token[0, 20] if user.password.blank?
    }
  end
end
