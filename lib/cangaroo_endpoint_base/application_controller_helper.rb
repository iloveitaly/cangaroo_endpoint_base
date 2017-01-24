module CangarooEndpointBase
  module ApplicationControllerHelper
    extend ActiveSupport::Concern

    included do
      include SimpleStructuredLogger
      include ActionController::HttpAuthentication::Basic::ControllerMethods

      http_basic_authenticate_with(
        name: '',
        # TODO this should be a gem-level config
        password: ENV['ENDPOINT_BASIC_AUTH_TOKEN']
      )

      before_action :reset_context

      rescue_from StandardError do |exception|
        # NOTE throw exceptions in test, otherwise failing tests won't fail loudly
        if Rails.env.test? && exception.class != CangarooEndpointBase::UserError
          raise(exception)
        end

        Rollbar.error(exception) if defined?(::Rollbar)

        render json: { :error => exception.message }, status: :internal_server_error
      end
    end

    protected

      def reset_context
        log.reset_context!
      end

      def poll_timestamps_from_params
        updated_before = updated_before_from_params_or_now

        updated_after = last_poll_from_params(allow_any: updated_before.present?)

        return if updated_after.nil?

        if updated_after >= updated_before
          render json: "updated_since later than updated_before", status: :bad_request
          return
        end

        [updated_after, updated_before]
      end

      def updated_before_from_params_or_now
        return DateTime.now if params[:updated_before].nil?

        Time.at(params[:updated_before].to_i).to_datetime
      end

      def last_poll_from_params(allow_any: false)
        last_poll = Time.at(params[:last_poll].to_i).to_datetime rescue nil

        if last_poll.nil?
          render json: "no last poll specified", status: :bad_request
          return
        end

        # TODO the env based limitation should be optional
        if !allow_any && Rails.env.production? && last_poll < 2.week.ago
          render json: "last poll should never be more than two weeks in the past", status: :bad_request
          return
        end

        last_poll
      end
  end
end
