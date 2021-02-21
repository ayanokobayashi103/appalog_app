class Shop < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :address, presence: true
  VALID_TIME_REGEX = /\A\d{2}[:]\d{2}$|^\d{1}[:]\d{2}\z/
  validates :start_dt, presence: true, format: { with: VALID_TIME_REGEX }
  validates :end_dt, presence: true, format: { with: VALID_TIME_REGEX }
  validates :detail, length: { maximum: 500 }
  VALID_TEL_REGEX = /\A\d{10}$|^\d{11}\z/
  validates :contact_detail, format: { with: VALID_TEL_REGEX }
  belongs_to :owner
  has_many :reviews, dependent: :destroy
  has_many :review_users, through: :reviews, source: :user
end
