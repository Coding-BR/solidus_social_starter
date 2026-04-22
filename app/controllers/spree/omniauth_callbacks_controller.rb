# frozen_string_literal: true

module Spree
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    attr_reader :user

    def self.provides_callback_for(*providers)
      providers.each do |provider|
        class_eval <<-SOURCE, __FILE__, __LINE__ + 1
          def #{provider}
            handle_callback
          end
        SOURCE
      end
    end

    provides_callback_for :facebook, :google_oauth2

    def handle_callback
      auth_hash = request.env['omniauth.auth']
      @user = Spree.user_class.from_omniauth(auth_hash)

      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: auth_hash.provider.capitalize) if is_navigational_format?
      else
        session['devise.omniauth_data'] = auth_hash.except('extra')
        # Use a hardcoded path if helper is missing
        redirect_to "/signup"
      end
    end

    def failure
      Rails.logger.error "OMNIAUTH FAILURE: #{request.env['omniauth.error.type']} - #{request.env['omniauth.error'].inspect}"
      set_flash_message(:error, :failure, kind: action_name.capitalize, reason: request.env['omniauth.error.type'] || 'Invalid credentials') if is_navigational_format?
      # Extremely defensive redirect
      redirect_to "/login"
    end

    protected

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || "/"
    end

    def after_omniauth_failure_path_for(_scope)
      "/login"
    end
  end
end
