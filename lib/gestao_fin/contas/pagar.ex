defmodule GestaoFin.Contas.Pagar do
  use Ecto.Schema
  alias GestaoFin.Categorias.Categoria
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "contas_pagars" do
    field :titulo, :string
    field :descricao, :string
    field :paga, :boolean
    field :valor, Money.Ecto.Amount.Type
    field :vencimento, :date

    belongs_to :categoria, Categoria

    timestamps()
  end

  def changeset(attrs \\ %{}), do: changeset(%__MODULE__{}, attrs)

  @doc false
  def changeset(pagar, attrs) do
    pagar
    |> cast(attrs, [:titulo, :vencimento, :valor, :descricao, :paga, :categoria_id])
    |> validate_required([:titulo, :vencimento, :valor, :categoria_id])
  end
end
