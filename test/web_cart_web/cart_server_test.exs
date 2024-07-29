defmodule WebCartWeb.CartServerTest do
  use ExUnit.Case, async: true
  alias WebCartWeb.{CartServer, Product}

  setup do
    # {:ok, _pid} = CartServer.start_link([])
    CartServer.empty_cart()
    :ok
  end

  describe "CartServer.get_products" do
    test "returns a list of products" do
      products = CartServer.get_products()
      assert map_size(products) == 3
    end
  end

  describe "CartServer.add_to_cart" do
    test "adds products to the cart" do
      CartServer.add_to_cart("GR1", 2)
      CartServer.add_to_cart("SR1", 1)
      cart = CartServer.get_cart()
      assert %WebCartWeb.CartItem{name: "Strawberries", price: 5.0, quantity: 1} = Map.get(cart, "SR1")
      assert ["GR1", "SR1"] = Map.keys(cart)
    end
  end

  describe "toggle_discount functionality" do
    test "applies discount_mode by default" do
      original_price = Map.get(CartServer.get_products(), "GR1").price
      CartServer.add_to_cart("GR1", 2)

      assert Map.get(CartServer.get_cart(), "GR1").price == original_price/2
    end

    test "turns off discount_mode" do
      CartServer.toggle_discount()
      CartServer.add_to_cart("GR1", 2)
      cart_price = Map.get(CartServer.get_cart(), "GR1").price
      original_price = Map.get(CartServer.get_products(), "GR1").price
      assert cart_price == original_price
      CartServer.toggle_discount()
    end
  end

  describe "reduce item count(-1)" do
    test "reduce_item_count" do
      CartServer.add_to_cart("CF1", 3)
      CartServer.reduce_item_count("CF1")
      assert Map.get(CartServer.get_cart(), "CF1").quantity == 2
    end

    test "tries to reduce_item_count for item which is not added" do
      cart = CartServer.add_to_cart("CF1", 2)
      CartServer.reduce_item_count("GR1")
      assert Map.get(CartServer.get_cart(), "CF1").quantity == 2
    end
  end
end
