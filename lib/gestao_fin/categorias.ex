defmodule GestaoFin.Categorias do
  alias GestaoFin.Categorias.Categoria
  alias GestaoFin.Repo

  import Ecto.Query

  def list_categorias, do: Repo.all(Categoria)

  def list_categorias_ativas do
    Categoria
    |> where([c], c.ativo == true)
    |> select([c], {c.nome, c.id})
    |> Repo.all()
  end

  def count_categorias(params \\ []) when is_list(params) do
    query = from(p in Categoria)

    params
    |> Enum.reduce(query, fn
      {:nome, nome}, query ->
        nome = "%" <> nome <> "%"
        where(query, [q], ilike(q.nome, ^nome))
    end)
    |> select([q], count(q.id))
    |> Repo.one()
  end

  def get!(id), do: Repo.get!(Categoria, id)

  def create_categoria(attrs \\ %{}) do
    attrs
    |> Categoria.changeset()
    |> Repo.insert()
  end

  def update_categoria(categoria, attrs) do
    categoria
    |> Categoria.changeset(attrs)
    |> Repo.update()
  end

  def delete_categoria(id) do
    id
    |> get!()
    |> Repo.delete()
  end

  def change_categoria(categoria, attrs \\ %{}), do: Categoria.changeset(categoria, attrs)
end
