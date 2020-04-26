class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Ensure that user has entered First Name
  validates_presence_of :first_name

  # Ensure that user has entered last Name
  validates_presence_of :surname

  # Ensure that user has entered an unique username
  validates_presence_of :username
  validates :username,
    uniqueness: true

  # # Ensure that user has enter a strong pwd
  # PASSWORD_STRENGTH = /\A
  #   (?=.{8,})          # At least 8 chars
  #   (?=.*[a-z])        # At least 1 lowercase
  #   (?=.*[A-Z])        # At least 1 uppercase
  #   (?=.*[[:^alnum:]]) # At least 1 special char
  # /x

  # validates :password,
  #     format: { with: PASSWORD_STRENGTH }

  # # Note. We do not need this field in database
  # attr_accessor :password_confirmation
  # validates_presence_of :password_confirmation
  validate :password_complexity

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[#?!@$%^&*-.,_])/

    errors.add :password, "Please use: 1 uppercase, 1 lowercase and 1 special character"
  end

  has_many :activities

  def recent_activities(limit)
    activities.order("created_at DESC").limit(limit)
  end

  # Linking user to projects shared
  has_many :projects_shared, through: :projects
end
