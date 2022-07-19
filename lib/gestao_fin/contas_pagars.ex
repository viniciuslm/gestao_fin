defmodule GestaoFin.ContasPagars do
  alias GestaoFin.Contas.Pagar
  alias GestaoFin.Repo

  import Ecto.Query

  def list_contas_pagar do
    Pagar
    |> preload([p], [:categoria])
    |> Repo.all()
  end

  def create_contas_pagar(attrs \\ %{}) do
    %Pagar{}
    |> Pagar.changeset(attrs)
    |> Repo.insert()
  end

  def count_contas_pagar(params \\ []) when is_list(params) do
    query = from(p in Pagar)

    params
    |> Enum.reduce(query, fn
      {:titulo, titulo}, query ->
        titulo = "%" <> titulo <> "%"
        where(query, [q], ilike(q.titulo, ^titulo))
    end)
    |> select([q], count(q.id))
    |> Repo.one()
  end

  def get!(id), do: Repo.get!(Pagar, id)

  def update_contas_pagar(contas_pagar, attrs) do
    contas_pagar
    |> Pagar.changeset(attrs)
    |> Repo.update()
  end

  def delete_contas_pagar(id) do
    id
    |> get!()
    |> Repo.delete()
  end

  def change_contas_pagar(contas_pagar, attrs \\ %{}),
    do: Pagar.changeset(contas_pagar, attrs)
end
