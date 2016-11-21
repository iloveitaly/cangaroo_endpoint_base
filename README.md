# CangarooEndpointBase

Simple gem with a application helper to easily build wombat/cangaroo endpoints for system integrations.

* Easily extract polling ranges (after, and time range) from params
* Throw errors to Rollbar
* Protect endpoint via HTTP basic auth
* Reset logging context before processing action

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cangaroo_endpoint_base'
```

In your `.env`:

```shell
export ENDPOINT_BASIC_AUTH_TOKEN=123123
```

This token will be used as the password for HTTP Basic authentication against this endpoint.

## Usage

```ruby
# application_controller.rb
class ApplicationController < ActionController::API
  include CangarooEndpointBase::ApplicationControllerHelper
end

# gift_cards_controller.rb
class GiftCardsController < ApplicationController
  def index
    updated_after, updated_before = poll_timestamps_from_params

    gift_card_poll_manager = GiftCardPollManager.new
    gift_card_poll_manager.poll(GiftCard, last_poll: updated_after, updated_before: updated_before)

    render json: { gift_cards: gift_card_poll_manager.updated_gift_cards }
  end

end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cangaroo_endpoint_base.
