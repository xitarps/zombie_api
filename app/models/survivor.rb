# frozen_string_literal: true

# Survivor model with custom overwrite #survivors method
class Survivor < ApplicationRecord
  has_many :infections, dependent: :nullify
  has_many :informers, through: :infections
  has_many :survivors, dependent: :nullify

  validates :name, presence: true

  enum :gender, { male: 4, female: 6 }

  before_create -> { self.token = SecureRandom.hex(3) }

  def survivors
    Survivor.joins(:infections).where(infections: { informer_id: id })
  end
end
