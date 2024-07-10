defmodule WebCartWeb.ProductTest do
  use ExUnit.Case
  alias WebCartWeb.Product

  describe "Product.new creation" do
    test "creates a new product struct" do
      product = Product.new(1, "Juice", 10)

      assert %Product{id: 1, name: "Juice", price: 10} = product
    end
  end
end
