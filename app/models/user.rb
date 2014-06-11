class User < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :validatable, :recoverable

  validate :first_name, :last_name, presence: true

  def name
    [first_name,last_name].reject(&:blank?).join(' ')
  end

end
