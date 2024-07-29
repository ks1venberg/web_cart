defmodule WebCartWeb.ProductTest do
  use ExUnit.Case
  alias WebCartWeb.{Product, CartServer, CartItem}

  describe "Product.new creation" do
    test "creates a new product struct" do
      product = Product.new("SR1", "Strawberries", 5.00)
      assert %Product{id: "SR1", name: "Strawberries", price: 5.00} = CartServer.get_products()["SR1"]
    end
  end
end
