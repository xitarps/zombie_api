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
end
