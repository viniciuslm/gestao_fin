defmodule GestaoFinWeb.HomeLive do
  use GestaoFinWeb, :live_view

  alias GestaoFin.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    {:ok,
     assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(user_token) end)}
  end
end
