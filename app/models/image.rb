class Image < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
end
