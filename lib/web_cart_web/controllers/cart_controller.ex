defmodule WebCartWeb.CartController do
  use WebCartWeb, :controller
  require Logger

  alias WebCartWeb.CartServer

  def cart(conn, _params) do
    cart = CartServer.get_cart()
    render(conn, "cart.html", cart: cart)
  end

  def add(conn, %{"id" => id, "quantity" => quantity} = item) do
    Logger.info("CartController add: \n #{inspect(item)}")
    CartServer.add_to_cart(id, String.to_integer(quantity))
    cart(conn, %{})
  end

  def remove(conn, %{"id" => id, "quantity" => quantity}) do
    CartServer.reduce_item_count(id, String.to_integer(quantity))
    cart(conn, %{})
  end

end
