# frozen_string_literal: true

require_relative 'setup'
require_relative 'helpers/account_document'


describe Mongoid::Timeline::Tracker do
  let!(:account_email) { 'homer.simpson@obscured.se' }
  let!(:type) { :comment }
  let!(:message) { 'Praesent a massa dui. Etiam eget purus consequat, mollis erat et, rhoncus tortor.' }
  let(:account) { Obscured::Account.new(email: account_email) }

  describe 'event' do
    before(:each) do
      account.save!
    end

    context 'add event' do
      let!(:event) { account.add_event(type: type, message: message, producer: account.id) }

      it { expect(event.type).to eq(type) }
      it { expect(event.message).to eq(message) }
      it { expect(event.proprietor).to eq(account_id: account.id) }
    end

    context 'get event' do
      let!(:event) { account.add_event(type: type, message: message, producer: account.id) }
      let(:response) { account.get_event(event.id) }

      it { expect(response.id).to eq(event.id) }
      it { expect(response.type).to eq(event.type) }
      it { expect(response.message).to eq(event.message) }
    end

    context 'get events' do
      let!(:event) { account.add_event(type: type, message: message, producer: account.id) }
      let!(:event2) { account.add_event(type: type, message: message, producer: account.id) }
      let(:response) { account.get_events }

      it { expect(response.count).to eq(2) }
    end

    context 'find events' do
      let(:response) { account.find_events({ type: :comment }, { }) }

      before(:each) do
        account.add_event(type: :comment, message: message, producer: account.id)
        account.add_event(type: :comment, message: message, producer: account.id)
        account.add_event(type: :foobar, message: message, producer: account.id)
      end

      it { expect(response.count).to eq(2) }
    end

    context 'search events' do
      before(:each) do
        5.times do
          account.add_event(type: :payment, message: message, producer: account.id)
        end

        10.times do
          account.add_event(type: :comment, message: message, producer: account.id)
        end
      end

      context 'with limit' do
        let(:response) { account.search_events(account.id, limit: 5) }

        it { expect(response.count).to eq(5) }
      end

      context 'with limit and type' do
        let(:response) { account.search_events(account.id, limit: 10, type: :payment) }

        it { expect(response.count).to eq(10) }
      end
    end

    context 'edit event' do
      let!(:event) { account.add_event(type: type, message: message, producer: account.id) }

      context 'updates message for the event' do
        before(:each) do
          account.edit_event(event.id, message: 'This is is a new message')
        end

        it { expect(account.get_event(event.id).message).to eq('This is is a new message') }
      end
    end

    context 'delete event' do
      let!(:event) { account.add_event(type: type, message: message, producer: account.id) }

      context 'deletes the event' do
        before(:each) do
          account.delete_event(event.id)
        end

        it { expect(account.get_event(event.id)).to be_nil }
      end
    end

    context 'clear events' do
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

      it { expect(account.get_events.count).to be(12) }

      context 'clear all event' do
        before(:each) do
          account.clear_events
        end

        it { expect(account.get_events.count).to be(0) }
      end
    end
  end
end