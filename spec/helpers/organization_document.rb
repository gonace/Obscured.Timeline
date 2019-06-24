module Obscured
  class Organization
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Timeline::Tracker

    store_in collection: "organizations"

    field :name, type: String
  end
end