defmodule Main.AppController do
  use Main.Web, :controller

  def index(conn, _params) do
    conn = Plug.Conn.put_resp_cookie(conn, "user_name", conn.assigns[:current_user].name)
    render conn, "index.html"
  end
end
