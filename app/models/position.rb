# frozen_string_literal: true

class Position < ApplicationRecord
  belongs_to :survivor

  validates :latitude, :longitude, presence: true
end
