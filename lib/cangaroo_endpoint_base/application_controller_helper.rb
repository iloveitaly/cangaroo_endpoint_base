module CangarooEndpointBase
  module ApplicationControllerHelper
    extend ActiveSupport::Concern

    included do
      include SimpleStructuredLogger
      include ActionController::HttpAuthentication::Basic::ControllerMethods

      http_basic_authenticate_with(
        name: '',
        password: ENV['ENDPOINT_BASIC_AUTH_TOKEN']
      )

      before_action :reset_context

      rescue_from StandardError do |exception|
        Rollbar.error(exception) if defined?(::Rollbar)

        render json: { :error => exception.message }, status: :internal_server_error
      end if !Rails.env.test?
    end

    protected

      def reset_context
        log.reset_context!
      end

      def last_poll_from_params
        last_poll = Time.at(params[:last_poll].to_i).to_datetime rescue nil

        if last_poll.nil?
          render json: "no last poll specified", status: :bad_request
          return
        end

        if Rails.env.production? && last_poll < 2.week.ago
          render json: "last poll should never be more than two weeks in the past", status: :bad_request
          return
        end

        last_poll
      end
  end
end
