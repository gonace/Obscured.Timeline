# frozen_string_literal: true

require_relative '../lib/obscured-timeline'
require_relative 'setup'
require_relative 'helpers/account_document'
require_relative 'helpers/organization_document'


describe Mongoid::Timeline::Tracker do
  let!(:account_email) { 'homer.simpson@obscured.se' }
  let!(:message) { 'Praesent a massa dui. Etiam eget purus consequat, mollis erat et, rhoncus tortor.' }
  let(:account) { Obscured::Account.new(email: account_email) }
  let(:organization) { Obscured::Organization.new(name: 'adeprimose') }

  describe 'write event' do
    context 'validates that that events is written to correct collection' do
      before(:each) do
        account.save!
        organization.save
      end
      let!(:account_event) { account.add_event(type: :comment, message: message, producer: account.email) }
      let!(:organization_event) { organization.add_event(type: :change, message: message, producer: account.email) }

      context 'for account' do
        it { expect(account_event.type).to eq(:comment) }
        it { expect(account_event.message).to eq(message) }
        it { expect(account_event.proprietor).to eq(account_id: account.id) }

        context 'get event' do
          let!(:event) { account.add_event(type: :comment, message: message, producer: account.email) }
          let!(:response) { account.get_event(event.id) }

          it { expect(response.id).to eq(event.id) }
          it { expect(response.type).to eq(event.type) }
          it { expect(response.message).to eq(event.message) }
        end

        context 'get events' do
          let!(:response) { account.get_events }

          it { expect(response.count).to eq(1) }
        end

        context 'find events' do
          let!(:event) { account.add_event(type: :comment, message: message, producer: account.email) }
          let!(:event2) { account.add_event(type: :foobar, message: message, producer: account.email) }
          let!(:event3) { account.add_event(type: :foobar, message: message, producer: account.email) }
          let!(:response) { account.find_events({ type: :foobar }, { }) }

          it { expect(response.count).to eq(2) }
        end

        context 'search events' do
          before(:each) do
            10.times do
              account.add_event(type: :comment, message: message, producer: account.email)
            end
          end

          let!(:event) { account.add_event(type: :comment, message: message, producer: account.email) }
          let!(:event2) { account.add_event(type: :comment, message: message, producer: account.email) }
          let!(:response) { account.search_events(account.email, limit: 5) }

          it { expect(response.count).to eq(5) }
        end
      end

      context 'for organization' do
        it { expect(organization_event.type).to eq(:change) }
        it { expect(organization_event.message).to eq(message) }
        it { expect(organization_event.proprietor).to eq(organization_id: organization.id) }

        context 'get event' do
          let!(:event) { organization.add_event(type: :comment, message: message, producer: organization.id) }
          let!(:response) { organization.get_event(event.id) }

          it { expect(response.id).to eq(event.id) }
          it { expect(response.type).to eq(event.type) }
          it { expect(response.message).to eq(event.message) }
        end

        context 'get events' do
          let!(:response) { organization.get_events }

          it { expect(response.count).to eq(1) }
        end

        context 'find events' do
          let!(:event) { organization.add_event(type: :comment, message: message, producer: organization.id) }
          let!(:event2) { organization.add_event(type: :foobar, message: message, producer: organization.id) }
          let!(:event3) { organization.add_event(type: :foobar, message: message, producer: organization.id) }
          let!(:response) { account.find_events({ type: :comment }, limit: 1) }

          it { expect(response.count).to eq(1) }
        end

        context 'search events' do
          before(:each) do
            10.times do
              organization.add_event(type: :comment, message: message, producer: organization.id)
            end
          end
          let!(:response) { organization.search_events(organization.id, limit: 5) }

          it { expect(response.count).to eq(5) }
        end
      end
    end
  end
end