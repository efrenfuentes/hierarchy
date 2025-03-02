defmodule Hierarchy.Queries.Parent do
  @moduledoc """
  Query expressions for the parent.
  """
  import Ecto.Query

  alias Hierarchy.{Helpers, LTree}

  @doc """
  Return query expressions for the parent
  """

  def query(%schema{} = struct) do
    parent_id =
      struct
      |> Helpers.struct_path()
      |> LTree.parent_id()

    [pk_column] = schema.__schema__(:primary_key)

    case parent_id do
      nil ->
        from(t in schema, where: 0 == 1)

      _ ->
        from(t in schema, where: field(t, ^pk_column) == ^parent_id)
    end
  end
end
