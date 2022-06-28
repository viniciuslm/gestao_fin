import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :gestao_fin, GestaoFin.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "gestao_fin_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gestao_fin, GestaoFinWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "yPbhULumx93ii2NIB7dnwqb9wRewBxRdnJoOChm064RoHl0tCQdhwztItKzOC+2R",
  server: false

# In test we don't send emails.
config :gestao_fin, GestaoFin.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
