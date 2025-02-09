defmodule ForTesting.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :hierarchy,
    adapter: Ecto.Adapters.Postgres
end
