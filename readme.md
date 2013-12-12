# SampleProject
* this is small sample from our real project called Uniliga
* sample covers player league requesting process
 * from controller, models, emails, services to view
* tests for all objects (services, models, emails) and end to end tests

## About project
* Uniliga is a place for players of tennis, bedminton, squash, etc. who want to play but have nobody to play with
* Player makes registration, send league request for his favourite sport
* After paying a fee players are split to groups and leagues according to their experience and league history

## How do I code
* I try to have slim controllers and models as well
* I put logic to pure ruby objects (services)
 * single responsibility principle
 * tell don't ask
* ActiveRecord is only input (for reading data) and output (for storing data) with defined interface
* I try to have all views (application, emails) very dummy and simple

## How do I test
* tests for models do load hole application
* services are tested in isolation without rails
 * stubs, mocks
* end to end tests (request) verify that small parts work (fit) together

## Why do I do it like that ?
* lots of small objects with one responsibility are better than small objects of lot of code with a lot of responsibility
* better architecture
* fewer bugs
* interfaces (object borders) are well defined
* it is much easier to swap some object for an other if I want change something
* only few request tests are needed
* unit testing is much easier
* tests that do not load rails are extremely fast

## Example

Interaction between model and service objects

```ruby
class SeasonTicket < ActiveRecord::Base
  # ....

  def due_date
    @due_date ||= DueDateCalculator.new(season).calculate
  end

  def calculate_price
    PriceList.price_for_season(season, SeasonPriceRules)
  end

  def order!
    self.price = calculate_price
    self.status = :ordered
    save!
    self
  end

  # ...
end

class DueDateCalculator
  def initialize(season)
    @season = season
  end

  def calculate
    @season.upcoming_round.start_date - 1.day
  end
end


class PriceList
  def self.price_for_season(season, season_price_rules)
    season_price_rules.full_season_price - (season_price_rules.one_round_price * season.started_rounds)
  end
end

```

unit tests for `PriceList`

```ruby
require_relative "../../app/services/price_list"
require_relative "../../app/services/season_price_rules"

describe PriceList do
  describe ".price_for_season" do
    it "should count price for active rounds (total round - started_rounds)" do
      season = double(:season, :started_rounds => 0)
      PriceList.price_for_season(season, SeasonPriceRules).should eq 12.0

      season = double(:season, :started_rounds => 1)
      PriceList.price_for_season(season, SeasonPriceRules).should eq 10.0

      season = double(:season, :started_rounds => 2)
      PriceList.price_for_season(season, SeasonPriceRules).should eq 8.0

      season = double(:season, :started_rounds => 3)
      PriceList.price_for_season(season, SeasonPriceRules).should eq 6.0
    end
  end
end
```

unit tests for `DueDateCalculator`

```ruby
require_relative "../../app/services/due_date_calculator"

describe DueDateCalculator do
  describe "#calculate" do
    let(:round) { double(:round, :start_date => Date.new(2013, 12, 28)) }
    let(:season) { double(:season, :upcoming_round => round) }

    subject { described_class.new(season) }

    it "should be one date before start of upcoming_round" do
      subject.calculate.should eq Date.new(2013, 12, 27)
    end
  end
end
```

unit tests for `SeasonTicket`

```ruby
require 'spec_helper'

describe SeasonTicket do
  # ....
  describe "#order!" do
    it "should count price, set status to :ordered and save ticket" do
      player = create(:player)
      season = create(:season)
      sport_region = create(:sport_region)

      PriceList.stub(:price_for_season).and_return(20.1)
      ticket = SeasonTicket.new(:player_id => player.id, :season_id => season.id, :sport_region_id => sport_region.id)
      ticket.order!

      ticket.price.should eq 20.1
      ticket.status.to_sym.should eq :ordered
      ticket.should be_persisted
    end
  end

  describe "#calculate_price" do
    it "should calculate price for season from ticket" do
      season = build(:season)
      ticket = SeasonTicket.new
      ticket.season = season

      PriceList.should_receive(:price_for_season).with(season, SeasonPriceRules).and_return(25.4)
      ticket.calculate_price.should eq 25.4
    end
  end
  # ...
end
```

## How fasts are tests without rails ?
* services with loading application

```
time rspec spec/services/due_date_calculator_spec.rb spec/services/price_list_spec.rb
 2/2 |============= 100 ===========>| Time: 00:00:00

Finished in 0.15365 seconds
2 examples, 0 failures

Randomized with seed 63520


real	0m9.238s
user	0m7.476s
sys	0m1.597s
```

so almost 10 seconds of waiting for test feedback in 0.12 seconds


* the same services with explicit dependency loading (no rails, no application)

```
time rspec spec/services/due_date_calculator_spec.rb spec/services/price_list_spec.rb
 2/2 |============= 100 ===========>| Time: 00:00:00

Finished in 0.00279 seconds
2 examples, 0 failures

real	0m0.415s
user	0m0.367s
sys	0m0.044s
```

feedback in less than 0.5 :)

## More ?
* for more information just browse the source code :)

## Resources
There is list of good resources that I've been inspired by

* https://www.destroyallsoftware.com/screencasts
* http://www.amazon.com/Growing-Object-Oriented-Software-Guided-Tests/dp/0321503627
* http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
* http://www.confreaks.com/videos/1314-rubyconf2012-boundaries
* http://www.confreaks.com/videos/759-rubymidwest2011-keynote-architecture-the-lost-years

## Licence

MIT: http://rem.mit-license.org
