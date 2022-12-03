# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Update Survivor' do
  let(:survivor) { Survivor.create(name: 'tester', gender: 'male') }

  context 'when request PUT /api/v1/survivors/:id' do
    context 'succeed' do
      it 'should return updated survivor' do
        put "/api/v1/survivors/#{survivor.id}", params: { survivor: { id: survivor.id, token: survivor.token,
                                                                      name: 'novo_nome', gender: 'female' } }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['name']).not_to eq('tester')
        expect(json_parse['name']).to eq('novo_nome')
      end
    end
    context 'failure' do
      it 'should return error when wrong token' do
        put "/api/v1/survivors/#{survivor.id}", params: { survivor: { id: survivor.id, token: SecureRandom.hex(3),
                                                                      name: 'novo_nome', gender: 'female' } }

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse.first).to include('Não autorizado')
      end
      it 'should return error when invalid attributes' do
        put "/api/v1/survivors/#{survivor.id}", params: { survivor: { id: survivor.id, token: survivor.token,
                                                                      name: '', gender: 'female' } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['name'].first).to include('branco')
      end
    end
  end
end
