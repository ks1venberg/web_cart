defmodule WebCartWeb.PageControllerTest do
  use WebCartWeb.ConnCase, async: false
  alias WebCartWeb.CartServer

  setup do
    CartServer.empty_cart()
    on_exit(fn -> CartServer.empty_cart() end)
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert response(conn, 200)
    assert %{discount_mode: "enabled", products: %{"CF1" => %WebCartWeb.Product{id: "CF1", name: "Coffee", price: 11.23}, "GR1" => %WebCartWeb.Product{id: "GR1", name: "Green tea", price: 3.11}, "SR1" => %WebCartWeb.Product{id: "SR1", name: "Strawberries", price: 5.0}}} = conn.assigns

  end

  test "POST /add_to_cart", %{conn: conn} do
    conn = post(conn, "/add_to_cart", %{"id" => "GR1", "quantity" => "2"})

    assert response(conn, 200)
    assert %{"GR1" => %WebCartWeb.CartItem{id: "GR1", name: "Green tea", default_price: 3.11, price: 1.55, quantity: 2}} = CartServer.get_cart()

  end
end
