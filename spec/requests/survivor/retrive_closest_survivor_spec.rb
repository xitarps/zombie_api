# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Retrive Colsest Survivor' do
  context 'when request GET /api/v1/survivors/:id/retrive_closest_survivor' do
    let!(:first_survivor) { Survivor.create(name: 'first_survivor') }
    let!(:second_survivor) { Survivor.create(name: 'second_survivor') }
    let!(:third_survivor) { Survivor.create(name: 'third_survivor') }

    context 'succeed' do
      it 'should return closest survivor with only longitude difference' do
        Position.delete_all
        Position.create(survivor: first_survivor, latitude: 90, longitude: 180)
        Position.create(survivor: second_survivor, latitude: 45, longitude: 90)
        Position.create(survivor: third_survivor, latitude: 45, longitude: 180)

        get "/api/v1/survivors/#{first_survivor.id}/retrive_closest_survivor"

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['name']).to eq('third_survivor')
      end

      it 'should return closest survivor with only latitude difference' do
        Position.delete_all
        Position.create(survivor: first_survivor, latitude: 90, longitude: 180)
        Position.create(survivor: second_survivor, latitude: 45, longitude: 90)
        Position.create(survivor: third_survivor, latitude: 90, longitude: 90)

        get "/api/v1/survivors/#{first_survivor.id}/retrive_closest_survivor"

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['name']).to eq('third_survivor')
      end
    end
  end
end
