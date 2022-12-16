defmodule GestaoFinWeb.Contas.PagarLive do
  use GestaoFinWeb, :live_view

  alias GestaoFin.Accounts
  alias GestaoFin.Contas.Pagar
  alias GestaoFin.ContasPagars
  alias GestaoFinWeb.ComponentLive.Delete
  alias GestaoFinWeb.ComponentLive.Empty
  alias GestaoFinWeb.Contas.PagarLive.{Form, Row}

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    {:ok,
     assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(user_token) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    titulo = params["titulo"] || ""

    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    total = ContasPagars.count_contas_pagar(titulo: titulo)
    paginate = %{page: page, per_page: per_page, total: total}

    sort_by = (params["sort_by"] || "updated_at") |> String.to_atom()
    sort_order = (params["sort_order"] || "desc") |> String.to_atom()
    sort = %{sort_by: sort_by, sort_order: sort_order}

    live_action = socket.assigns.live_action
    user_id = socket.assigns.current_user.id
    contas_pagars = ContasPagars.list_contas_pagar_by_user_id(user_id)

    assigns = [
      contas_pagars: contas_pagars,
      titulo: titulo,
      loading: false,
      options: sort,
      names: []
    ]

    options = Map.merge(paginate, sort)

    socket =
      socket
      |> apply_action(live_action, params)
      |> assign(assigns)
      |> assign(options: options)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    delete(socket, id)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Criar nova conta a pagar")
    |> assign(:contas_pagar, %Pagar{})
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    contas_pagar = ContasPagars.get!(id)

    socket
    |> assign(:page_title, "Editar conta a pagar")
    |> assign(:contas_pagar, contas_pagar)
  end

  defp apply_action(socket, :delete, %{"id" => id}) do
    contas_pagar = ContasPagars.get!(id)

    socket
    |> assign(:page_title, "Excluir conta a pagar")
    |> assign(:contas_pagar, contas_pagar)
  end

  defp delete(socket, id) do
    {:ok, _} = ContasPagars.delete_contas_pagar(id)

    {:noreply,
     socket
     |> put_flash(:info, "Conta a pagar excluída!")
     |> push_redirect(to: Routes.pagar_path(socket, :index))}
  end
end
