defmodule GestaoFinWeb.PageController do
  use GestaoFinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
