class User < ApplicationRecord
  has_many :explorations, dependent: :destroy
  
  validates :fullname, :city, :bio, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, if: :password_required?
  
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google_payload(payload)
    user = find_or_initialize_by(email: payload['email'])
    user.assign_attributes(
      google_id: payload['sub'],
      fullname: payload['given_name'],
      picture: payload['picture'],
      city: user.city.presence || "Not specified",
      bio: user.bio.presence || "No bio yet"
    )
    user.save(validate: false)
    user
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create/update user: #{e.message}"
    nil
  end

  def password_required?
    google_id.blank? && super
  end
end
