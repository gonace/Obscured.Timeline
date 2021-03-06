# frozen_string_literal: true

require 'active_support/concern'

module Obscured
  module Timeline
    module Tracker
      extend ActiveSupport::Concern

      class Record
        include Obscured::Timeline::Record
      end

      # Adds event to the x_timeline collection for document. This is
      # only called on manually.
      #
      # @example Add event.
      #   document.add_event
      #
      # @return [ document ]
      def add_event(event)
        Record.with(collection: "#{self.class.name.demodulize.downcase}_timeline") do |m|
          m.make!(event.merge(proprietor: { "#{self.class.name.demodulize.downcase}_id".to_sym => id }))
        end
      end

      # Get an event from the x_timeline collection for document. This is
      # only called on manually.
      #
      # @example Get event.
      #   document.get_event(id)
      #
      # @return [ document ]
      def get_event(id)
        Record.with(collection: "#{self.class.name.demodulize.downcase}_timeline") do |m|
          m.find(id)
        end
      end

      # Get events from the x_timeline collection for document by proprietor. This is
      # only called on manually.
      #
      # @example Get event.
      #   document.get_events
      #   document.events
      #
      # @return [ documents ]
      def get_events
        Record.with(collection: "#{self.class.name.demodulize.downcase}_timeline") do |m|
          m.by(proprietor: { "#{self.class.name.demodulize.downcase}_id".to_sym => id })
        end
      end
      alias events get_events

      # Find events from the x_timeline collection for document. This is
      # only called on manually.
      #
      # @example Get event.
      #   document.find_events(params, options)
      #
      # @return [ documents ]
      def find_events(params, options)
        Record.with(collection: "#{self.class.name.demodulize.downcase}_timeline") do |m|
          m.by({ proprietor: { "#{self.class.name.demodulize.downcase}_id".to_sym => id } }.merge(params), options)
        end
      end

      # Search events from the x_timeline collection for document. This is
      # only called on manually.
      #
      # @example Get event.
      #   document.search_events(text, options)
      #
      # @return [ documents ]
      def search_events(text, options)
        limit = options[:limit].blank? ? nil : options[:limit].to_i
        skip = options[:skip].blank? ? nil : options[:skip].to_i
        order = options[:order].blank? ? :created_at.desc : options[:order]

        Record.with(collection: "#{self.class.name.demodulize.downcase}_timeline") do |m|
          query = {}
          query[:type] = options[:type].to_sym if options[:type]
          query[:severity] = options[:severity].to_sym if options[:severity]

          criteria = m.where(query).full_text_search(text)
          criteria = criteria.order_by(order) if order
          criteria = criteria.limit(limit).skip(skip)

          docs = criteria.to_a
          docs
        end
      end

      # Edit an event from the x_timeline collection by id. This is
      # only called on manually.
      #
      # @example Get event.
      #   document.edit_event(id, params)
      #
      # @return [ document ]
      def edit_event(id, params = {})
        Record.with(collection: "#{self.class.name.demodulize.downcase}_timeline") do |m|
          event = m.where(id: id).first
          event.message = params[:message] if params[:message]
          event.save
          event
        end
      end

      # Delete an event from the x_timeline collection by id. This is
      # only called on manually.
      #
      # @example Get event.
      #   document.get_event(id)
      #
      # @return [ document ]
      def delete_event(id)
        Record.with(collection: "#{self.class.name.demodulize.downcase}_timeline") do |m|
          m.where(id: id).delete
        end
      end

      # Clear events from the x_timeline collection for document. This is
      # only called on manually.
      #
      # @example Get event.
      #   document.clear_events
      #
      # @return [ documents ]
      def clear_events
        Record.with(collection: "#{self.class.name.demodulize.downcase}_timeline") do |m|
          m.where(proprietor: { "#{self.class.name.demodulize.downcase}_id".to_sym => id }).delete
        end
      end
    end
  end
end
