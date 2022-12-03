# frozen_string_literal: true

class Survivor < ApplicationRecord
  validates :name, presence: true

  enum :gender, { male: 4, female: 6 }

  before_create -> { self.token = SecureRandom.hex(3) }
end
