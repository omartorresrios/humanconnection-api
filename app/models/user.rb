class User < ApplicationRecord
  has_many :explorations, dependent: :destroy
  
  validates :fullname, :password, presence: true
  validates :email, presence: true, uniqueness: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
