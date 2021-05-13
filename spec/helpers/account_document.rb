module Obscured
  class Account
    include Mongoid::Document
    include Mongoid::Timestamps
    include Obscured::Timeline::Tracker

    store_in collection: "accounts"

    field :email, type: String
  end
end