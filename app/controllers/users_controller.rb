class UsersController < ApplicationController
    # Invoked if ANY route is accessed in the application,
    # ... but only specific to the auto_login route.
    before_action :authorized, only: [:auto_login]

    # REGISTER
    def create 
        @user = User.create(user_params)
        if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else 
            render json: {error: "Invalid username or password"}
        end 
    end 

    # LOGGING IN
    def login
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else 
            render json: {error: "Invalid username or password"}
        end 
    end 

    # There’s really not much going on here. The big question is where the variable @user comes from?
    # Since the method, authorized, will run before auto_login, the chain of methods in the application 
    # controller will also run. One of the methods, logged_in_user, will return a global @user variable 
    # that is accessible.
    def auto_login 
        render json: @user
    end 

    private 

    def user_params
        params.permit(:username, :password, :age)
    end 
end
