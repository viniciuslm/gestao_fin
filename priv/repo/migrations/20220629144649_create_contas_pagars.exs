defmodule GestaoFin.Repo.Migrations.CreateContasPagars do
  use Ecto.Migration

  def change do
    create table(:contas_pagars, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :titulo, :string
      add :descricao, :string
      add :vencimento, :date
      add :valor, :integer
      add :paga, :boolean, default: false, null: false

      timestamps()
    end
  end
end
