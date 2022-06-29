defmodule GestaoFin.Contas.Pagar do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "contas_pagars" do
    field :titulo, :string
    field :descricao, :string
    field :paga, :boolean, default: false
    field :valor, :integer
    field :vencimento, :date

    timestamps()
  end

  @doc false
  def changeset(pagar, attrs) do
    pagar
    |> cast(attrs, [:nome, :vencimento, :valor, :paga])
    |> validate_required([:nome, :vencimento, :valor, :paga])
  end
end
