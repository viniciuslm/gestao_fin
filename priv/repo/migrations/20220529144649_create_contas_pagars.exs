defmodule GestaoFin.Repo.Migrations.CreateContasPagars do
  use Ecto.Migration

  def change do
    create table(:contas_pagars, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :titulo, :string, null: false
      add :descricao, :string
      add :vencimento, :date, null: false
      add :valor, :integer, null: false
      add :paga, :boolean, default: false, null: false

      add :categoria_id,
          references(:categorias,
            on_delete: :nilify_all,
            on_update: :nilify_all,
            type: :binary_id,
            null: false
          )

      timestamps()
    end

    create index(:contas_pagars, [:categoria_id])
  end
end
