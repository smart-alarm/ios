class UsersController < ApplicationController

	def login
		#render login.html.erb
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:notice] = "User created! The user_id is #{@user.id}"
			redirect_to(:root)
		else
			render('new')
		end
	end

	def authenticate
		if params[:email].present? && params[:password].present?
			user = User.where(:email => params[:email]).first
			if user
				authorized_user = user.authenticate(params[:password])
				if authorized_user
					flash[:notice] = "Login successful!"
					redirect_to(:root)
				else
					flash[:notice] = "Invalid email/password."
					redirect_to(:root)
				end
			end
		else
			flash[:notice] = "Invalid email/password."
			redirect_to(:root)
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end

end
