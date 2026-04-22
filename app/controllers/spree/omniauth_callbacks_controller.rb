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
        redirect_to new_spree_user_registration_url
      end
    end

    def failure
      set_flash_message(:error, :failure, kind: action_name.capitalize, reason: 'Invalid credentials') if is_navigational_format?
      redirect_to spree_login_path
    end

    protected

    def after_omniauth_failure_path_for(_scope)
      spree_login_path
    end
  end
end
