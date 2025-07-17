# frozen_string_literal: true

module Api
  module V1
    # VotesController handles the voting actions for the API
    class VotesController < ApplicationController
      def create
        result = Voting::CastVoteService.call(user: current_user, candidate_name: params[:candidate_name])

        if result.success?
          render json: {message: "Vote recorded", candidate: result.candidate}, status: :ok
        else
          render json: {error: result.error}, status: :unprocessable_entity
        end
      end
    end
  end
end
