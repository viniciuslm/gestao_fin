defmodule GestaoFin.Contas.Receber do
  use Ecto.Schema
  import Ecto.Changeset
  alias GestaoFin.Accounts.User
  alias GestaoFin.Categorias.Categoria

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "contas_recebers" do
    field :titulo, :string
    field :descricao, :string
    field :recebida, :boolean
    field :valor, Money.Ecto.Amount.Type
    field :vencimento, :date

    belongs_to :categoria, Categoria
    belongs_to :user, User

    timestamps()
  end

  def changeset(attrs \\ %{}), do: changeset(%__MODULE__{}, attrs)

  @doc false
  def changeset(pagar, attrs) do
    pagar
    |> cast(attrs, [:titulo, :vencimento, :valor, :descricao, :recebida, :categoria_id, :user_id])
    |> validate_required([:titulo, :vencimento, :valor, :categoria_id])
  end
end
