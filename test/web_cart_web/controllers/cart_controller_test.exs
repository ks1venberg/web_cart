defmodule WebCartWeb.CartControllerTest do
  use WebCartWeb.ConnCase, async: false
  alias WebCartWeb.CartServer

  setup do
    CartServer.empty_cart()
    on_exit(fn -> CartServer.empty_cart() end)
  end

  test "GET /cart", %{conn: conn} do
    conn = get(conn, "/cart")

    assert response(conn, 200)
    assert %{discount_mode: "enabled", cart: %{}, total: 0.0} = conn.assigns

  end

  test "POST /cart/add", %{conn: conn} do
    conn = post(conn, "/cart/add", %{"id" => "GR1", "quantity" => "2"})

    assert response(conn, 200)
    assert CartServer.get_cart() == %{"GR1" => %WebCartWeb.CartItem{id: "GR1", name: "Green tea", default_price: 3.11, price: 1.55, quantity: 2}}
  end

  test "POST /cart/add with discounts ON", %{conn: conn} do
    post(conn, "/cart/add", %{"id" => "SR1", "quantity" => "3"})

    assert CartServer.get_state().discount_mode == "enabled"
    assert CartServer.get_cart() == %{"SR1" => %WebCartWeb.CartItem{id: "SR1", name: "Strawberries", default_price: 5.0, price: 4.5, quantity: 3}}

  end

  test "POST /cart/drop", %{conn: conn} do
    CartServer.add_to_cart("SR1", 3)
    post(conn, "/cart/drop", %{"id" => "SR1", "quantity" => "-1"})

    assert %{"SR1" => %WebCartWeb.CartItem{id: "SR1", name: "Strawberries", default_price: 5.0, price: 5.0, quantity: 2}} = CartServer.get_cart()

  end

end
