# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survivor, type: :model do
  context 'when has a name' do
    it 'should persist in database' do
      subject.name = 'test'
      subject.save

      expect(subject).to be_persisted
    end
  end

  context 'when has no name' do
    it 'should not be valid' do
      subject.name = nil

      expect(subject).not_to be_valid
    end
  end

  context '#survivors' do
    it 'should return survivors marked as infected by specific informer' do
      informer = Survivor.create(name: 'informer')
      first_survivor = Survivor.create(name: 'first')
      second_survivor = Survivor.create(name: 'second')
      third_survivor = Survivor.create(name: 'third')

      first_survivor.infections.create(informer: informer)
      third_survivor.infections.create(informer: informer)

      expect(informer.survivors).to match_array [first_survivor, third_survivor]
      expect(informer.survivors).not_to include(second_survivor)
    end
  end
end
