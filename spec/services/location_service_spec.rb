# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationService do
  context '.call' do
    let!(:first_survivor) { Survivor.create(name: 'first_survivor') }
    let!(:second_survivor) { Survivor.create(name: 'second_survivor') }
    let!(:third_survivor) { Survivor.create(name: 'third_survivor') }
    Position.delete_all

    it 'should return closest survivor' do
      Position.delete_all
      Position.create(survivor: first_survivor, latitude: 90, longitude: 180)
      Position.create(survivor: second_survivor, latitude: 80, longitude: 170)
      Position.create(survivor: third_survivor, latitude: 45, longitude: 90)
      expect(LocationService.call(first_survivor)).to eq second_survivor
    end

    it 'should return one closest survivor even when has two with equal distance' do
      Position.delete_all
      Position.create(survivor: first_survivor, latitude: 90, longitude: 180)
      Position.create(survivor: second_survivor, latitude: 80, longitude: 170)
      Position.create(survivor: third_survivor, latitude: 80, longitude: 170)
      expect(LocationService.call(first_survivor).class).to eq Survivor
    end

    it 'should return one closest survivor even when has two with equal distance wihtout itself' do
      Position.delete_all
      Position.create(survivor: first_survivor, latitude: -85, longitude: -175)
      Position.create(survivor: second_survivor, latitude: -85, longitude: -175)
      Position.create(survivor: third_survivor, latitude: -85, longitude: -175)
      expect(LocationService.call(first_survivor).class).not_to eq first_survivor
    end

    it 'should return closest survivor even when position is negative' do
      Position.delete_all
      Position.create(survivor: first_survivor, latitude: 85, longitude: 175)
      Position.create(survivor: second_survivor, latitude: 0, longitude: 0)
      Position.create(survivor: third_survivor, latitude: -85, longitude: -175)
      expect(LocationService.call(first_survivor)).to eq third_survivor
    end

    it 'should return closest survivor even when survivors positions are negative' do
      Position.delete_all
      Position.create(survivor: first_survivor, latitude: -80, longitude: -170)
      Position.create(survivor: second_survivor, latitude: -40, longitude: -60)
      Position.create(survivor: third_survivor, latitude: 90, longitude: 180)
      expect(LocationService.call(first_survivor)).to eq third_survivor
    end

    it 'should return empty array if no one else' do
      Position.delete_all
      Infection.delete_all
      Survivor.delete_all
      expect(LocationService.call(first_survivor)).to be_nil
    end
  end
end
