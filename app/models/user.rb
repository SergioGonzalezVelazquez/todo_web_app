class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Ensure that user has entered First Name
  validates_presence_of :first_name, message: 'Enter your first name' 

  # Ensure that user has entered last Name
  validates_presence_of :surname, message: 'Enter your last name' 

  # Ensure that user has entered username
  validates_presence_of :username, message: 'Enter your username' 


  # Ensure that user has enter a strong pwd
  PASSWORD_STRENGTH = /\A
    (?=.{8,})          # At least 8 chars
    (?=.*[a-z])        # At least 1 lowercase
    (?=.*[A-Z])        # At least 1 uppercase
    (?=.*[[:^alnum:]]) # At least 1 special char
  /x

  validates_presence_of :password, message: 'Enter your password' 
  validates :password, 
      format: { with: PASSWORD_STRENGTH,  message: "Enter a strong password"}

end
