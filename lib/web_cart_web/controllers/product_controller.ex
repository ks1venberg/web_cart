defmodule WebCartWeb.ProductController do
  use WebCartWeb, :controller

  alias WebCartWeb.CartServer

  def home(conn, _params) do
    products = CartServer.get_products()
    render(conn, :home, products: products)
  end
end
