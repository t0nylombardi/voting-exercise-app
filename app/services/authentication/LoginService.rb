# frozen_string_literal: true

require "ostruct"

module Authentication
  # Service object responsible for logging in or registering a user
  # based on provided email, zip code, and password.
  class LoginService
    # @param params [Hash] the parameters required to log in
    # @option params [String] :email the user's email address
    # @option params [String] :zip_code the user's zip code
    # @option params [String] :password the user's password (not validated for correctness)
    def initialize(params)
      @params = params
    end

    # Class method for convenience — instantiates and calls the service
    #
    # @param params [Hash] login parameters (see `#initialize`)
    # @return [OpenStruct] result object with success?, user or error
    def self.call(params)
      new(params).call
    end

    # Executes the login logic — creates a new user if necessary
    #
    # @return [OpenStruct] object with:
    #   - success?: [Boolean]
    #   - user: [User] if successful
    #   - error: [String] if failure
    def call
      return failure("Missing email or zip code") unless valid_params?

      user = find_or_create_user

      if user.save
        success(user: user)
      else
        failure(user.errors.full_messages.to_sentence) unless user.valid?
      end
    end

    private

    # @return [Hash] raw params passed into the service
    attr_reader :params

    # Finds an existing user by email or creates a new one.
    # Assigns zip code and password.
    #
    # @return [User] the user object
    # @raise [ActiveRecord::RecordInvalid] if save! fails
    def find_or_create_user
      user = User.find_or_initialize_by(email: params[:email])
      user.assign_attributes(zip_code: params[:zip_code], password: params[:password])
      user.save! if user.new_record? || user.changed?
      user
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message)
    end

    # Builds a success result
    #
    # @param user [User]
    # @return [OpenStruct] result with success: true
    def success(user:)
      OpenStruct.new(success?: true, user: user)
    end

    # Builds a failure result
    #
    # @param error_message [String]
    # @return [OpenStruct] result with success: false
    def failure(error_message)
      OpenStruct.new(success?: false, error: error_message)
    end

    # Checks if the params contain the minimum required fields
    #
    # @return [Boolean] true if valid
    def valid_params?
      params[:email].present? && params[:zip_code].present?
    end
  end
end
