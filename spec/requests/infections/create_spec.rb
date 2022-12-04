# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create Infection' do
  let(:survivor) { Survivor.create(name: 'moribundo', gender: 'male') }
  let(:third_informer) { Survivor.create(name: 'x9', gender: 'female') }
  let(:second_informer) { Survivor.create(name: 'x8', gender: 'male') }
  let(:first_informer) { Survivor.create(name: 'x7') }

  context 'when request POST /api/v1/infections' do
    context 'with three infections marked' do
      it 'should return the survivor as infected' do
        survivor.infections.create(survivor: survivor, informer: first_informer)
        survivor.infections.create(survivor: survivor, informer: second_informer)

        post '/api/v1/infections', params: { infection: { informer: { id: third_informer.id,
                                                                      token: third_informer.token },
                                                          survivor: { id: survivor.id } } }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['infected']).to eq(true)
      end
    end

    context 'with less than three infections marked' do
      it 'should return the survivor as not infected' do
        survivor.infections.create(survivor: survivor, informer: first_informer)

        post '/api/v1/infections', params: { infection: { informer: { id: second_informer.id,
                                                                      token: second_informer.token },
                                                          survivor: { id: survivor.id } } }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['infected']).to eq(false)
      end
    end

    context 'with wrong token' do
      it 'should return invalid infection data error' do
        post '/api/v1/infections', params: { infection: { informer: { id: third_informer.id,
                                                                      token: 'wrong_token' },
                                                          survivor: { id: survivor.id } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse.first).to include('incorreto')
      end
    end

    context 'with wrong informer id' do
      it 'should return invalid infection data error' do
        post '/api/v1/infections', params: { infection: { informer: { id: SecureRandom.uuid,
                                                                      token: third_informer.token },
                                                          survivor: { id: survivor.id } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse.first).to include('incorreto')
      end
    end

    context 'with wrong survivor id' do
      it 'should return invalid infection data error' do
        post '/api/v1/infections', params: { infection: { informer: { id: third_informer.id,
                                                                      token: third_informer.token },
                                                          survivor: { id: SecureRandom.uuid } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse.first).to include('incorreto')
      end
    end

    context 'with infection already registered by the same informer' do
      it 'should return already registered infection error' do
        survivor.infections.create(survivor: survivor, informer: third_informer)
        post '/api/v1/infections', params: { infection: { informer: { id: third_informer.id,
                                                                      token: third_informer.token },
                                                          survivor: { id: survivor.id } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_parse['informer_id'].first).to include('já registrad')
      end
    end
  end
end
