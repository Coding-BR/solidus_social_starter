# frozen_string_literal: true

module Spree
  class UserSocialAuthentication < Spree::Base
    belongs_to :user, class_name: Spree.user_class.to_s

    validates :provider, :uid, presence: true
    validates :uid, uniqueness: { scope: :provider }
  end
end
