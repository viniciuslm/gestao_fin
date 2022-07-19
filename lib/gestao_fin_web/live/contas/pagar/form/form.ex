defmodule GestaoFinWeb.Contas.PagarLive.Form do
  use GestaoFinWeb, :live_component
  alias GestaoFin.Categorias
  alias GestaoFin.ContasPagars

  def update(%{contas_pagar: contas_pagar} = assigns, socket) do
    changeset = ContasPagars.change_contas_pagar(contas_pagar)
    categorias = Categorias.list_categorias_ativas()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)
     |> assign(categorias: categorias)
     |> assign(contas_pagar: contas_pagar)}
  end

  def handle_event("validate", %{"pagar" => contas_pagar_params}, socket) do
    changeset =
      socket.assigns.contas_pagar
      |> ContasPagars.change_contas_pagar(contas_pagar_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"pagar" => contas_pagar_params}, socket) do
    action = socket.assigns.action
    save(socket, action, contas_pagar_params)
  end

  defp save(socket, :new, contas_pagar_params) do
    case ContasPagars.create_contas_pagar(contas_pagar_params) do
      {:ok, _contas_pagar} ->
        {:noreply,
         socket
         |> put_flash(:info, "Conta a pagar criada!")
         |> redirect(to: Routes.pagar_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save(socket, :edit, contas_pagar_params) do
    contas_pagar = socket.assigns.contas_pagar

    case ContasPagars.update_contas_pagar(contas_pagar, contas_pagar_params) do
      {:ok, _contas_pagar} ->
        {:noreply,
         socket
         |> put_flash(:info, "Conta a pagar atualizada!")
         |> redirect(to: Routes.pagar_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
