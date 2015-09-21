class User < ActiveRecord::Base

	#Includes:
	#password, password_confirmation, and password_digest fields and authenticate method
	has_secure_password

	has_one :morning_routine

	#Validators
	validates :email, :presence => true, :uniqueness => true

end
