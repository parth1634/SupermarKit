class User < ActiveRecord::Base
  authenticates_with_sorcery!
  validates :password, confirmation: true, length: { minimum: 3 }
  validates :password_confirmation, presence: true

  validates :name, presence: true
  validates :email, uniqueness: true

  has_and_belongs_to_many :user_groups
  has_many :items, through: :user_groups

  acts_as_user roles: :admin

  scope :with_name, ->(q) { where('users.name LIKE ?', "%#{q}%").distinct }
end