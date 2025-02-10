defmodule Hierarchy.Queries.Root do
  @moduledoc """
  Query expressions for the root.
  """
  import Ecto.Query

  alias Hierarchy.{Helpers, LTree}

  @doc """
  Return query expressions for the root
  """
  def query(%schema{} = struct) do
    condition = root_condition(struct)

    from(schema, where: ^condition)
  end

  defp root_condition(%_schema{} = struct) do
    path = Helpers.struct_path(struct)

    [{pk_column, value}] = Ecto.primary_key(struct)
    root_id = LTree.root_id(path, value)

    dynamic([q], field(q, ^pk_column) == ^root_id)
  end
end
