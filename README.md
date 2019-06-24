# Obscured::Timeline
## Introduction
Obscured timeline adds event to a separate collection for an entity (Document), the naming of the class (Mongoid Document) is used for naming the timeline collection, so if the class is named "Account" the collection name will end up being "account_timeline".

## Installation
### Requirements
- activesupport
- mongoid
- mongoid_search

##### Add this line to your application's Gemfile
```ruby
gem 'Obscured.Timeline, :git => 'git@github.com:gonace/Obscured.Timeline.git', :branch => 'master'
```

##### Execute
```
$ bundle
```

### Usage
#### Base
Use this in files where you create non-default log collections.
```ruby
require 'obscured-timeline'
```


### Example
#### Usage
```ruby
require 'obscured-timeline'

module Obscured
  class Account
    include Mongoid::Document
    include Mongoid::Timestamps
    include Obscured::Timeline::Tracker
    
    field :name, type: String
    field :email, type: String
  end
end


account = Obscured::Account.create(:name => "John Doe", :email => "john.doe@obscured.se")
event = account.add_event({ type: :comment, message: "Lorem ipsum dolor sit amet?", producer: "homer.simpson@obscured.se" })

#returns array of events for document (proprietor)
account.get_events 

#returns event by id
account.get_event(event.id.to_s)

#returns array of events by predefined params, supports pagination
account.find_events({ type: nil, producer: nil }, { limit: 20, skip: 0, order: :created_at.desc, only: [:id, :type, :message, :producer, :created_at, :updated_at, :proprietor] })

#retuns array of events
account.search_events("homer.simpson@obscured.se", { type: :comment, limit: 20, skip: 0, order: :created_at.desc }) 
```