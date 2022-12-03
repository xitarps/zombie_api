# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Show Survivor' do
  let(:subject) { Survivor.create(name: 'tester', gender: 'male') }

  context 'when request GET /api/v1/survivors/:id' do
    context 'succeed' do
      it 'should return the survivor' do
        get "/api/v1/survivors/#{subject.id}"

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['name']).to eq('tester')
      end
    end
    context 'failure' do
      it 'should return error' do
        id_from_no_one = SecureRandom.uuid
        get "/api/v1/survivors/#{id_from_no_one}"

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse.first).to include("Não foi possivel localizar pelo id: #{id_from_no_one}")
      end
    end
  end
end
