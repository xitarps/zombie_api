# frozen_string_literal: true

# Survivors Controller
class Api::V1::SurvivorsController < Api::V1::ApiController
  def create
    survivor = Survivor.new(survivor_params)

    return render json: survivor, status: :created if survivor.save

    render json: survivor.errors.as_json, status: :unprocessable_entity
  end

  def show
    survivor = Survivor.find(params[:id])
    render json: survivor.filtered_survivor, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: [I18n.t('activerecord.exceptions.not_found', id: params[:id])], status: :not_found
  end

  def update
    survivor = fetch_authenticated_survivor

    if survivor.update(survivor_params) && survivor.position.update(survivor_position_params)
      return render json: survivor,
                    status: :ok
    end

    render json: survivor.errors.as_json, status: :unprocessable_entity
  rescue StandardError
    render json: [I18n.t('activerecord.exceptions.unauthorized', id: params[:id])], status: :unauthorized
  end

  def retrive_closest_survivor
    render json: LocationService.call(fetch_survivor)&.filtered_survivor
  end

  private

  def survivor_params
    params.require(:survivor).permit(:name, :gender)
  end

  def survivor_position_params
    params.require(:survivor).permit(:latitude, :longitude)
  end

  def fetch_authenticated_survivor
    Survivor.where(id: params[:survivor][:id], token: params[:survivor][:token]).first
  end

  def fetch_survivor
    Survivor.where(id: params[:id])&.first
  end
end
