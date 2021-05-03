class AddPublicToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :public, :boolean, default: false
  end
end
