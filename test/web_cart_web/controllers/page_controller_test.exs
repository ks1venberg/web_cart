defmodule WebCartWeb.PageControllerTest do
  use WebCartWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "WebCart application"
  end
end
