defmodule GestaoFin.Repo do
  use Ecto.Repo,
    otp_app: :gestao_fin,
    adapter: Ecto.Adapters.Postgres
end
