# frozen_string_literal: true

module Foundation
  # Optional demo catalog rows (SPEC M10.3).
  #
  # The application boots and serves every page with an empty database, so no
  # seed is ever required. These rows exist only to make the storefront and
  # checkout walkable on a developer machine or in a hosted preview, and they
  # are refused everywhere else — a production deployment must never find
  # invented products in its catalog.
  module DemoSeeds
    PRODUCTS = [
      {
        slug: "harbor-harbor-espresso", sku: "HR-ESP-001", name: "Harbor Espresso",
        description: "A dark, syrupy espresso blend built to cut through milk. Cocoa and toasted hazelnut, with a long bittersweet finish.",
        price_cents: 1_650, position: 0, inventory_quantity: 80,
        roast_level: "dark", origin: "Brazil / Sumatra blend",
        tasting_notes: "Cocoa, toasted hazelnut, brown sugar",
        bag_weight_grams: 340,
        image_url: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=1200&q=80"
      },
      {
        slug: "morning-light", sku: "HR-FLT-001", name: "Morning Light",
        description: "A bright, clean filter roast for pour-over and drip. Juicy acidity with orange zest and a honeyed sweetness.",
        price_cents: 1_750, position: 1, inventory_quantity: 60,
        roast_level: "light", origin: "Ethiopia, Yirgacheffe",
        tasting_notes: "Orange zest, jasmine, honey",
        bag_weight_grams: 340,
        image_url: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80"
      },
      {
        slug: "foghorn-blend", sku: "HR-BLN-001", name: "Foghorn Blend",
        description: "Our flagship house blend — balanced, approachable, and dependable. Medium roast with milk chocolate and caramel.",
        price_cents: 1_500, position: 2, inventory_quantity: 120,
        roast_level: "medium", origin: "Colombia / Guatemala blend",
        tasting_notes: "Milk chocolate, caramel, red apple",
        bag_weight_grams: 340,
        image_url: "https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=1200&q=80"
      },
      {
        slug: "tidewater-decaf", sku: "HR-DEC-001", name: "Tidewater Decaf",
        description: "Swiss water-processed decaf that keeps the flavor. Smooth, nutty, and gentle enough for after dinner.",
        price_cents: 1_600, position: 3, inventory_quantity: 90,
        roast_level: "medium-dark", origin: "Colombia (Swiss water process)",
        tasting_notes: "Almond, cocoa, vanilla",
        bag_weight_grams: 340,
        image_url: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=1200&q=80"
      },
      {
        slug: "breakwater-single-origin", sku: "HR-SIN-001", name: "Breakwater Single Origin",
        description: "A delicate single origin from the highlands of Kenya. Complex, winey, and bright — for the slow mornings.",
        price_cents: 1_950, position: 4, inventory_quantity: 45,
        roast_level: "medium-light", origin: "Kenya, Nyeri",
        tasting_notes: "Blackcurrant, grapefruit, raw sugar",
        bag_weight_grams: 340,
        image_url: "https://images.unsplash.com/photo-1461988320302-91bde64fc8e4?auto=format&fit=crop&w=1200&q=80"
      },
      {
        slug: "nightwatch-espresso", sku: "HR-ESP-002", name: "Nightwatch Espresso",
        description: "An extra-dark roast for the late shift. Smoky, bold, and low-acid, with dark chocolate and molasses.",
        price_cents: 1_700, position: 5, inventory_quantity: 70,
        roast_level: "dark", origin: "Sumatra, Mandheling",
        tasting_notes: "Dark chocolate, molasses, cedar",
        bag_weight_grams: 340,
        image_url: "https://images.unsplash.com/photo-1512568400610-62da28bc8a13?auto=format&fit=crop&w=1200&q=80"
      }
    ].freeze

    # Development or a hosted preview only. Preview runs in the production
    # Rails environment, so the preview flag — not RAILS_ENV alone — is what
    # separates a disposable demo from a real deployment.
    def self.permitted?(rails_env: Rails.env, preview: Foundation.preview?)
      rails_env.development? || preview
    end

    def self.run!(io: $stdout)
      unless permitted?
        io.puts("Skipping demo seeds: they are limited to development and hosted previews.")
        return 0
      end

      unless Foundation.storefront_enabled?
        io.puts("Skipping demo seeds: the storefront is disabled in config/foundation.yml.")
        return 0
      end

      created = seed_products!
      io.puts("Demo catalog ready: #{PRODUCTS.length} products (#{created} created).")
      created
    end

    # Upserts by slug so repeated runs converge on the same catalog instead of
    # duplicating rows.
    def self.seed_products!
      created = 0

      PRODUCTS.each do |attributes|
        product = Foundation::Storefront::Product.find_or_initialize_by(slug: attributes[:slug])
        created += 1 if product.new_record?
        product.update!(**attributes, currency: "USD", active: true)
      end

      created
    end
  end
end
