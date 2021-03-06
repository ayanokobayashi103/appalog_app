class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reviews, dependent: :destroy
  has_many :review_shops, through: :reviews, source: :shop
  has_many :active_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :passive_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com', name: 'ゲストユーザー') do |user|
    # ランダムで URL-safe な base64 文字列を生成して返します。
    user.password = SecureRandom.urlsafe_base64
    end
  end
end
