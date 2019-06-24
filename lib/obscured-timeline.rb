require 'mongoid'
require 'mongoid_search'

Mongoid::Search.setup do |cfg|
  cfg.strip_symbols = /[\"]/
  cfg.strip_accents = //
end

require 'obscured-timeline/record'
require 'obscured-timeline/service'
require 'obscured-timeline/tracker'

module Mongoid
  module Timeline
  end
end