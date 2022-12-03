# frozen_string_literal: true

# Survivors Controller
class Api::V1::SurvivorsController < Api::V1::ApiController
  def create
    @survivor = Survivor.new(survivor_params)

    return render json: @survivor, status: :created if @survivor.save

    render json: @survivor.errors.as_json, status: :unprocessable_entity
  end

  private

  def survivor_params
    params.require(:survivor).permit(:name, :gender)
  end
end
