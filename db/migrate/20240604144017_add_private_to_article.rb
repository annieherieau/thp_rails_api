class AddPrivateToArticle < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :private, :boolean, default: true
  end
end
