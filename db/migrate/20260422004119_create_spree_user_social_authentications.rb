class CreateSpreeUserSocialAuthentications < ActiveRecord::Migration[7.2]
  def change
    create_table :spree_user_social_authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid

      t.timestamps
    end
    add_index :spree_user_social_authentications, :user_id
    add_index :spree_user_social_authentications, :uid
  end
end
