defmodule WebCartWeb.PageController do
  use WebCartWeb, :controller

  alias WebCartWeb.CartServer

  def home(conn, _params) do
    products = CartServer.get_products()
    discount_mode = CartServer.get_state()
    render(conn, :home, [layout: false, products: products, discount_mode: discount_mode])
  end

  # Adds an item to the cart
  def add_to_cart(conn, %{"id" => id, "quantity" => quantity}) do
    CartServer.add_to_cart(id, String.to_integer(quantity))
    home(conn, cart: CartServer.get_cart())
  end

  # Activates discount mode
  def discounts(conn, __params) do
    discount_mode = CartServer.toggle_discount()
    home(conn, discount_mode: discount_mode)
  end

end
