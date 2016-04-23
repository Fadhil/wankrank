defmodule Wankrank.PageControllerTest do
  use Wankrank.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Listing videos"
  end
end
