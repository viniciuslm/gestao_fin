defmodule GestaoFinWeb.CategoriaLive do
  use GestaoFinWeb, :live_view

  alias GestaoFin.Accounts
  alias GestaoFin.Categorias
  alias GestaoFin.Categorias.Categoria
  alias GestaoFinWeb.CategoriaLive.Form
  alias GestaoFinWeb.CategoriaLive.Row
  alias GestaoFinWeb.ComponentLive.Delete
  alias GestaoFinWeb.ComponentLive.Empty

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    {:ok,
     assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(user_token) end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    nome = params["nome"] || ""

    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    total = Categorias.count_categorias(nome: nome)
    paginate = %{page: page, per_page: per_page, total: total}

    sort_by = (params["sort_by"] || "updated_at") |> String.to_atom()
    sort_order = (params["sort_order"] || "desc") |> String.to_atom()
    sort = %{sort_by: sort_by, sort_order: sort_order}

    live_action = socket.assigns.live_action
    categorias = Categorias.list_categorias()

    assigns = [
      categorias: categorias,
      nome: nome,
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
    |> assign(:page_title, "Criar nova categoria")
    |> assign(:categoria, %Categoria{})
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    categoria = Categorias.get!(id)

    socket
    |> assign(:page_title, "Editar categoria")
    |> assign(:categoria, categoria)
  end

  defp apply_action(socket, :delete, %{"id" => id}) do
    categoria = Categorias.get!(id)

    socket
    |> assign(:page_title, "Excluir categoria")
    |> assign(:categoria, categoria)
  end

  defp delete(socket, id) do
    {:ok, _} = Categorias.delete_categoria(id)

    {:noreply,
     socket
     |> put_flash(:info, "Categoria excluída!")
     |> push_redirect(to: Routes.categoria_path(socket, :index))}
  end
end
