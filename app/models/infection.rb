# frozen_string_literal: true

# Infections pivot model for survivors to survivors(informers)
class Infection < ApplicationRecord
  belongs_to :survivor, class_name: 'Survivor'
  belongs_to :informer, class_name: 'Survivor'

  validates :survivor_id, :informer_id, presence: true
  validates :informer_id, uniqueness: { scope: :survivor_id, message: I18n.t('errors.messages.infection_duplicated') }

  after_save :confirm_infection

  private

  def confirm_infection
    survivor = Survivor.find(survivor_id)
    survivor.update(infected: true) if survivor.infections.size >= 3
  end
end
