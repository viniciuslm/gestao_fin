defmodule GestaoFin.ContasRecebers do
  alias GestaoFin.Contas.Receber
  alias GestaoFin.Repo

  import Ecto.Query

  def list_contas_receber do
    Receber
    |> preload([p], [:categoria])
    |> Repo.all()
  end

  def list_contas_receber_by_user_id(user_id) do
    Receber
    |> where([r], r.user_id == ^user_id)
    |> Repo.all()
  end

  def create_contas_receber(attrs \\ %{}) do
    %Receber{}
    |> Receber.changeset(attrs)
    |> Repo.insert()
  end

  def count_contas_receber(params \\ []) when is_list(params) do
    query = from(p in Receber)

    params
    |> Enum.reduce(query, fn
      {:titulo, titulo}, query ->
        titulo = "%" <> titulo <> "%"
        where(query, [q], ilike(q.titulo, ^titulo))
    end)
    |> select([q], count(q.id))
    |> Repo.one()
  end

  def get!(id), do: Repo.get!(Receber, id)

  def update_contas_receber(contas_receber, attrs) do
    contas_receber
    |> Receber.changeset(attrs)
    |> Repo.update()
  end

  def delete_contas_receber(id) do
    id
    |> get!()
    |> Repo.delete()
  end

  def change_contas_receber(contas_receber, attrs \\ %{}),
    do: Receber.changeset(contas_receber, attrs)
end
