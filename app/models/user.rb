class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :trackable, :validatable, :recoverable, :token_authenticatable

  validates :first_name, :last_name, presence: true

  def self.admins
    where("email LIKE ? or email LIKE ?", "%@codeforkids.ca", "%@code-for-kids.com")
  end

  def self.kids
    where("email NOT LIKE ? and email NOT LIKE ?", "%@codeforkids.ca", "%@code-for-kids.com")
  end

  def name
    [first_name,last_name].reject(&:blank?).join(' ')
  end

  def can_administer?
    email.present? && (email.end_with?("@codeforkids.ca") || email.end_with?("@code-for-kids.com"))
  end

end
