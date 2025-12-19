class ChangePublicToIsPublic < ActiveRecord::Migration[7.1]
  def change
    rename_column :continents, :public, :is_public
    rename_column :continent_images, :public, :is_public
  end
end
