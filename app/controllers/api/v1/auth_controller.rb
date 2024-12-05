require_relative '../../application_controller'
require_relative '../../../models/user'

module Api
  module V1
    class AuthController < ApplicationController
      def login
        user = User.find(params.slice(:username, :password))
        if user
          token = JwtUtils.encode({ user_id: user.id })
          render json: { token: }, status: 200
        else
          render json: { message: 'Invalid credentials' }, status: 401
        end
      end
    end
  end
end
