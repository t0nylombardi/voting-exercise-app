# frozen_string_literal: true

Shoulda::Matchers.configure do |c|
  c.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

module Shoulda
  module Matchers
    module Patches
      # Patches the +validates_length_of+ matcher to allow you to specify the
      # specific character used when testing the length of an attribute.
      #
      # ##### with_test_character
      #
      # Use `with_test_character` when you want to specify the specific
      # character used when setting the value of the attribute to test its
      # length.
      #
      #     class User
      #       include ActiveModel::Model
      #       attr_accessor :zip_code
      #       normalizes :zip_code, with: -> { _1.delete("^[0-9]") }
      #
      #       validates_length_of :zip_code, maximum: 9
      #     end
      #
      #     # RSpec
      #     RSpec.describe User, type: :model do
      #       it do
      #         should validate_length_of(:zip_code),
      #           is_at_most(9).
      #           with_test_character("4")
      #       end
      #     end
      module ValidateLengthOfMatcher
        def initialize(*)
          super
          @test_character = "x"
        end

        def with_test_character(character)
          if character.present?
            @test_character = character
          end

          self
        end

        def value_of_length(length)
          if array_column?
            [@test_character] * length
          elsif collection_association?
            Array.new(length) { association_reflection.klass.new }
          else
            @test_character * length
          end
        end
      end
    end
  end
end

Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher.prepend(Shoulda::Matchers::Patches::ValidateLengthOfMatcher)
