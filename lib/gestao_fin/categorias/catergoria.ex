defmodule GestaoFin.Categorias.Categoria do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categorias" do
    field :nome, :string
    field :descricao, :string
    field :ativo, :boolean

    timestamps()
  end

  def changeset(attrs \\ %{}), do: changeset(%__MODULE__{}, attrs)

  @doc false
  def changeset(categoria, attrs) do
    categoria
    |> cast(attrs, [:nome, :descricao, :ativo])
    |> validate_required([:nome, :ativo])
    |> unique_constraint(:nome)
  end
end
