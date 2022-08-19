defmodule GestaoFinWeb.Contas.ReceberLive.Form do
  use GestaoFinWeb, :live_component
  alias GestaoFin.Categorias
  alias GestaoFin.ContasRecebers

  def update(%{contas_receber: contas_receber} = assigns, socket) do
    changeset = ContasRecebers.change_contas_receber(contas_receber)
    categorias = Categorias.list_categorias_ativas()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)
     |> assign(categorias: categorias)
     |> assign(contas_receber: contas_receber)}
  end

  def handle_event("validate", %{"receber" => contas_receber_params}, socket) do
    changeset =
      socket.assigns.contas_receber
      |> ContasRecebers.change_contas_receber(contas_receber_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"receber" => contas_receber_params}, socket) do
    action = socket.assigns.action
    save(socket, action, contas_receber_params)
  end

  defp save(socket, :new, contas_receber_params) do
    case ContasRecebers.create_contas_receber(contas_receber_params) do
      {:ok, _contas_receber} ->
        {:noreply,
         socket
         |> put_flash(:info, "Conta a receber criada!")
         |> push_redirect(to: Routes.receber_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save(socket, :edit, contas_receber_params) do
    contas_receber = socket.assigns.contas_receber

    case ContasRecebers.update_contas_receber(contas_receber, contas_receber_params) do
      {:ok, _contas_receber} ->
        {:noreply,
         socket
         |> put_flash(:info, "Conta a receber atualizada!")
         |> push_redirect(to: Routes.receber_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
