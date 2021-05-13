# frozen_string_literal: true

require_relative 'setup'
require_relative 'helpers/account_document'
require_relative 'helpers/account_service'


describe Obscured::Timeline::Service::Account do
  let!(:account) { Obscured::Account.new(email: 'homer.simpsons@obscured.se') }
  let!(:message) { 'Praesent a massa dui. Etiam eget purus consequat, mollis erat et, rhoncus tortor.' }
  let!(:service) { Obscured::Timeline::Service::Account.new }

  before(:each) do
    2.times do
      account.add_event(type: :event, message: message, producer: account.email)
    end
    5.times do
      account.add_event(type: :comment, message: message, producer: account.email)
    end
    5.times do
      account.add_event(type: :change, message: message, producer: account.email)
    end
  end

  describe 'all' do
    let(:response) { service.all }

    it { expect(response.count).to eq(12) }
  end

  describe 'find' do
    let!(:event) { account.add_event(type: :change, message: message, producer: account.id) }
    let(:response) { service.find(event.id) }

    it { expect(response).to_not be(nil) }
    it { expect(response.id).to eq(event.id) }
  end

  describe 'find_by' do
    let!(:event) { account.add_event(type: :change, message: message, producer: account.id) }
    let(:response) { service.find_by(type: :change) }

    it { expect(response).to_not be(nil) }
    it { expect(response.count).to eq(1) }
  end

  describe 'by' do
    context 'proprietor' do
      let(:response) { service.by(proprietor: { account_id: account.id }) }

      it { expect(response.length).to eq(12) }
    end

    context 'type' do
      let(:response) { service.by(type: :comment) }

      it { expect(response.count).to eq(5) }
    end

    context 'proprietor and type' do
      let(:response) { service.by(type: :event, proprietor: { account_id: account.id }) }

      it { expect(response.length).to eq(2) }
    end
  end

  describe 'where' do
    context 'returns correct documents' do
      let(:response) { service.where(type: :event) }

      it { expect(response.count).to eq(2) }
    end
  end

  describe 'delete' do
    context 'deletes document by id' do
      let!(:event) { account.add_event(type: :change, message: message, producer: account.id) }

      it { expect(service.delete(event.id.to_s)).to eq(1) }
    end
  end
end