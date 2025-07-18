# frozen_string_literal: true

# Handles API user login and logout for API V1.
# This controller simulates authentication by creating or finding a user.
#
# Routes:
#   POST   /api/v1/login   → api/v1/sessions#create
#   DELETE /api/v1/logout  → api/v1/sessions#destroy
module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token

      # Logs in a user by creating or retrieving a User via LoginService.
      # Stores the user ID in the Rails session.
      #
      # @return [JSON] JSON response containing success or error message and user data
      def create
        result = Authentication::LoginService.call(login_params)

        if result.success?
          session[:user_id] = result.user.id
          render json: {message: "Logged in", user: result.user}, status: :ok
        else
          render json: {error: result.error}, status: :unprocessable_entity
        end
      end

      # Logs out the current user by clearing the session.
      #
      # @return [void]
      def destroy
        session[:user_id] = nil
        head :no_content
      end

      private

      # Strong parameter handling for login.
      #
      # @return [ActionController::Parameters]
      def login_params
        params.permit(:email, :password, :zip_code)
      end
    end
  end
end
