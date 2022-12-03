# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create Survivor' do
  context 'when request POST /api/v1/survivors' do
    context 'succeed' do
      it 'should return the survivor' do
        post '/api/v1/survivors', params: { survivor: { name: 'tester', gender: 'male' } }

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['name']).to eq('tester')
      end
    end
    context 'failure' do
      it 'should return error' do
        post '/api/v1/survivors', params: { survivor: { gender: 'male' } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['name'].first).to include('branco')
      end
    end
  end
end
