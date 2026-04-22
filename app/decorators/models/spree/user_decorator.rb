# frozen_string_literal: true

module SolidusSocialStarter
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.has_many :user_social_authentications, class_name: 'Spree::UserSocialAuthentication', dependent: :destroy
        base.extend ClassMethods
      end

      module ClassMethods
        def from_omniauth(auth)
          authentication = Spree::UserSocialAuthentication.find_by(provider: auth.provider, uid: auth.uid)
          return authentication.user if authentication

          user = find_by(email: auth.info.email)
          user ||= create!(
            email: auth.info.email,
            password: Devise.friendly_token[0, 20],
            name: auth.info.name
          )

          user.user_social_authentications.create!(provider: auth.provider, uid: auth.uid)
          user
        end
      end

      ::Spree.user_class.prepend self
    end
  end
end
