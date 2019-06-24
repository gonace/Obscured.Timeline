module Obscured
  class Account
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Timeline::Tracker

    store_in collection: "accounts"

    field :email, type: String
  end
end