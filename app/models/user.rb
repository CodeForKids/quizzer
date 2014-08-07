class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :trackable, :validatable, :recoverable, :token_authenticatable
  has_many :quiz_assignments, dependent: :destroy

  after_destroy :delete_associations

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

  def answer_groups
    Rapidfire::AnswerGroup.where(user: self)
  end

  def delete_associations
    self.answer_groups.each do |ag|
      ag.answers.delete_all
    end
    self.answer_groups.delete_all
    self.quiz_assignments.delete_all
  end

end
