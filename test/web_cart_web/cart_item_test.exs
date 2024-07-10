defmodule WebCartWeb.CartItemTest do
  use ExUnit.Case
  alias WebCartWeb.{Product, CartItem}

  describe "CartItem.new" do
    test "creates a new cart item" do
      product = Product.new(1, "Product 1", 100)
      cart_item = CartItem.new(product)

      assert %CartItem{product: ^product, quantity: 1} = cart_item
    end
  end
end
