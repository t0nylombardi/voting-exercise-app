# frozen_string_literal: true

module Authentication
  class LoginService

    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

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

    attr_reader :params

    def find_or_create_user
      user = User.find_or_initialize_by(email: params[:email])
      user.assign_attributes(zip_code: params[:zip_code], password: params[:password])
      user.save! if user.new_record? || user.changed?
      user
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message)
    end

    def success(user:)
      OpenStruct.new(success?: true, user: user)
    end

    def failure(error_message)
      OpenStruct.new(success?: false, error: error_message)
    end

    def valid_params?
      params[:email].present? && params[:zip_code].present?
    end
  end
end
