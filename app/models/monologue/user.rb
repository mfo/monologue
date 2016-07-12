class Monologue::User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_many :posts, class_name: 'Monologue::Post', inverse_of: 'user'

  field :name, type: String
  field :email, type: String

  field :password_digest, type: String

  has_secure_password

  validates_presence_of :password, on: :create
  validates_presence_of :name
  validates :email, presence: true, uniqueness: true

  def can_delete?(user)
    return false if self == user
    return false if user.posts.any?
    true
  end
end
