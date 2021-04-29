class User < ApplicationRecord
  before_save   :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false}
  has_secure_password
  validates :password, presence: true
  has_many :images, dependent: :destroy

  def downcase_email
    self.email = email.downcase
  end
end
