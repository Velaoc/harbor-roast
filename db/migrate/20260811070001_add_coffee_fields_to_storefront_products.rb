class AddCoffeeFieldsToStorefrontProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :storefront_products, :roast_level, :string, null: false, default: "medium"
    add_column :storefront_products, :origin, :string, null: false, default: ""
    add_column :storefront_products, :tasting_notes, :string, null: false, default: ""
    add_column :storefront_products, :bag_weight_grams, :integer, null: false, default: 340

    add_check_constraint :storefront_products,
      "roast_level IN ('light','medium-light','medium','medium-dark','dark')",
      name: "storefront_products_roast_level_allowed"
    add_check_constraint :storefront_products,
      "bag_weight_grams > 0",
      name: "storefront_products_bag_weight_positive"
  end
end
