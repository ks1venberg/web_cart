defmodule WebCartWeb.CartItemTest do
  use ExUnit.Case
  alias WebCartWeb.{CartServer, Product, CartItem}

  setup do

    # {:ok, _pid} = CartServer.start_link([])
    CartServer.empty_cart()
    :ok
  end

  describe "CartItem.new" do
    test "creates a new cart item without dicsount" do
      product = Product.new("GR1", "Green tea", 3.11)
      cart_item = CartServer.add_to_cart(product.id, 1)

      assert %CartItem{name: "Green tea", quantity: 1, price: 3.11} = Map.get(CartServer.get_cart(), "GR1")
    end
  end
end
