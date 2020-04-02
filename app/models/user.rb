class User < ApplicationRecord
    # A task is created by a user
    has_many :tasks

    # A project is created by a user
    has_many :projects

    # macro to utilize Bcrypt methods
    has_secure_password

    # Ensure that user has entered First Name
    validates_presence_of :first_name, message: 'Enter your first name' 

    # Ensure that user has entered last Name
    validates_presence_of :surname, message: 'Enter your last name' 

    # Ensure that user has entered username
    validates_presence_of :username, message: 'Enter your username' 

    # Ensure that user has entered a valid email address
    validates_presence_of :email, message: 'Enter your email address' 
    validates :email, 
        uniqueness: true,
        format: { with: URI::MailTo::EMAIL_REGEXP, message: "Enter a valid email address" }

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

    # Note. We do not need this field in database
    attr_accessor :password_confirmation
    validates_presence_of :password_confirmation, message: 'Confirm your password' 
    
    # Automatically validates if :password == :password_confirmation
    validates_confirmation_of :password
end
