# frozen_string_literal: true

# Infections controller to handle with marking survivors as infected
class Api::V1::InfectionsController < Api::V1::ApiController
  def create
    informer = fetch_informer
    survivor = fetch_survivor

    unless informer && survivor
      return render json: [I18n.t('errors.messages.wrong_infection_data')],
                    status: :unprocessable_entity
    end

    infection = Infection.new(informer: informer, survivor: survivor)

    return render json: survivor.reload.filtered_survivor, status: :ok if infection.save

    render json: infection.errors.as_json, status: :unprocessable_entity
  end

  private

  def fetch_informer
    Survivor.where(id: params[:infection][:informer][:id],
                   token: params[:infection][:informer][:token]).first
  end

  def fetch_survivor
    Survivor.where(id: params[:infection][:survivor][:id]).first
  end
end
