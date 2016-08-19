module CangarooEndpointBase
  module SpecHelper
    def setup_http_basic_auth
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic
        .encode_credentials('', ENV['ENDPOINT_BASIC_AUTH_TOKEN'])

      # force JSON type so ruby hash => json string on post/patch/etc
      request.env['CONTENT_TYPE'] = 'application/json'
    end

    def parsed_response(parse = false)
      if @parsed_response.blank? || parse
        @parsed_response = JSON.parse(response.body)
      end

      @parsed_response
    end

    def read_fixture(name)
      JSON.parse(File.read(File.join(Rails.root, "spec/support/fixtures/#{name}.json")))
    end
  end
end

RSpec.configure do |config|
  config.include CangarooEndpointBase::SpecHelper, type: :controller
end
