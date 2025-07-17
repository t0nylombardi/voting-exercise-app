# frozen_string_literal: true

module Api
  module V1
    class ResultsController < ApplicationController
      def index
        results = Voting::ResultsFetcher.call
        render json: results
      end
    end
  end
end
