class AddDefaultPictureToItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :image

    add_column :items, :image, :string, default: "https://images.onerichs.com/CIP/preview/thumbnail/uscm/9840"
  end
end
