defmodule WebCartWeb.CartController do
  use WebCartWeb, :controller

  alias WebCartWeb.CartServer

  def cart(conn, _params) do
    cart = CartServer.get_cart()
    discount_mode = CartServer.get_state().discount_mode
    total = CartServer.calculate_total()

    render(conn, :cart, [ layout: false, cart: cart, total: total, discount_mode: discount_mode])
  end

  def add(conn, %{"id" => id, "quantity" => quantity}) do
    CartServer.add_to_cart(id, String.to_integer(quantity))
    cart(conn, %{})
  end

  def drop(conn, %{"id" => id, "quantity" => quantity}) do
    CartServer.drop_item_count(id, String.to_integer(quantity))
    cart(conn, %{})
  end

  def remove(conn, %{"id" => id}) do
    CartServer.remove_from_cart(id)
    cart(conn, %{})
  end

  def empty_cart(conn, %{}) do
    CartServer.empty_cart()
    cart(conn, %{})
  end

end
