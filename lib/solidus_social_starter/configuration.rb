# frozen_string_literal: true

module SolidusSocialStarter
  class Configuration
    attr_accessor :facebook_app_id, :facebook_app_secret, :google_client_id, :google_client_secret

    def providers
      {
        facebook: { api_key: facebook_app_id, api_secret: facebook_app_secret },
        google_oauth2: { api_key: google_client_id, api_secret: google_client_secret }
      }
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
