import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :hierarchy, ecto_repos: [ForTesting.Repo]

config :hierarchy, ForTesting.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "hierarchy_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# Print only warnings and errors during test
config :logger, level: :warning
