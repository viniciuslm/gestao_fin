defmodule GestaoFinWeb.Contas.ReceberLive do
  use GestaoFinWeb, :live_view
  alias GestaoFin.Contas.Receber
  alias GestaoFin.ContasRecebers
  alias GestaoFinWeb.ComponentLive.Delete
  alias GestaoFinWeb.ComponentLive.Empty
  alias GestaoFinWeb.Contas.ReceberLive.{Form, Row}

  @impl true
  def mount(_p, _s, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    titulo = params["titulo"] || ""

    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    total = ContasRecebers.count_contas_receber(titulo: titulo)
    paginate = %{page: page, per_page: per_page, total: total}

    sort_by = (params["sort_by"] || "updated_at") |> String.to_atom()
    sort_order = (params["sort_order"] || "desc") |> String.to_atom()
    sort = %{sort_by: sort_by, sort_order: sort_order}

    live_action = socket.assigns.live_action
    contas_recebers = ContasRecebers.list_contas_receber()

    assigns = [
      contas_recebers: contas_recebers,
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
    |> assign(:page_title, "Criar nova conta a receber")
    |> assign(:contas_receber, %Receber{})
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    contas_receber = ContasRecebers.get!(id)

    socket
    |> assign(:page_title, "Editar conta a receber")
    |> assign(:contas_receber, contas_receber)
  end

  defp apply_action(socket, :delete, %{"id" => id}) do
    contas_receber = ContasRecebers.get!(id)

    socket
    |> assign(:page_title, "Excluir conta a receber")
    |> assign(:contas_receber, contas_receber)
  end

  defp delete(socket, id) do
    {:ok, _} = ContasRecebers.delete_contas_receber(id)

    {:noreply,
     socket
     |> put_flash(:info, "Conta a receber excluída!")
     |> push_redirect(to: Routes.receber_path(socket, :index))}
  end
end
