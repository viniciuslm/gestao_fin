defmodule GestaoFinWeb.CategoriaLive.Form do
  use GestaoFinWeb, :live_component
  alias GestaoFin.Categorias

  def update(%{categoria: categoria} = assigns, socket) do
    changeset = Categorias.change_categoria(categoria)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)
     |> assign(categoria: categoria)}
  end

  def handle_event("validate", %{"categoria" => categoria_params}, socket) do
    changeset =
      socket.assigns.categoria
      |> Categorias.change_categoria(categoria_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"categoria" => categoria_params}, socket) do
    action = socket.assigns.action
    save(socket, action, categoria_params)
  end

  defp save(socket, :new, categoria_params) do
    case Categorias.create_categoria(categoria_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Categoria criada!")
         |> redirect(to: Routes.categoria_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save(socket, :edit, categoria_params) do
    product = socket.assigns.product

    case Categorias.update_categoria(product, categoria_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Categoria atualizada!")
         |> redirect(to: Routes.categoria_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
