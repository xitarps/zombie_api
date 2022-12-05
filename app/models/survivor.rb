# frozen_string_literal: true

# Survivor model with custom overwrite #survivors method
class Survivor < ApplicationRecord
  has_many :infections, dependent: :nullify
  has_many :informers, through: :infections
  has_many :survivors, dependent: :nullify
  has_one  :position, dependent: :destroy, class_name: 'Position'

  validates :name, presence: true

  enum :gender, { male: 4, female: 6 }

  before_create -> { self.token = SecureRandom.hex(3) }
  after_create :generate_position_if_dosent_have_one

  def survivors
    Survivor.joins(:infections).where(infections: { informer_id: id })
  end

  def filtered_survivor
    as_json.tap do |survivor|
      %w[created_at updated_at token].each do |attribute|
        survivor.delete(attribute)
      end
      survivor['latitude'] = position&.latitude
      survivor['longitude'] = position&.longitude
    end
  end

  private

  def generate_position_if_dosent_have_one
    Position.create(survivor: self,
                    latitude: rand(-90.0..90.0).round(6),
                    longitude: rand(-180.0..180.0).round(6))
  end
end
