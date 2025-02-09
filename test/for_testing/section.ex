defmodule ForTesting.Section do
  @moduledoc """
  Section model for testing.
  """

  use Ecto.Schema
  use Hierarchy

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "sections" do
    field(:name, :string)
    field(:path, Hierarchy.Ecto.UUIDLTree)

    timestamps()
  end
end
