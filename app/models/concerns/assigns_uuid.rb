# frozen_string_literal: true

module AssignsUuid
  extend ActiveSupport::Concern

  included do
    before_create :assign_uuid
  end

  private

  def assign_uuid
    self.id ||= SecureRandom.uuid
  end
end
