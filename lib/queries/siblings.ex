defmodule Hierarchy.Queries.Siblings do
  @moduledoc """
  Query expressions for siblings.
  """
  import Ecto.Query

  alias Hierarchy.Helpers

  @doc """
  Return query expressions for siblings
  ## Options

    * `:include_self` - when true to include itself. Default is false.
  """
  def query(%schema{} = struct, opts \\ []) do
    condition = siblings_with_self_condition(struct)

    if Keyword.get(opts, :include_self, false) do
      from(schema, where: ^condition)
    else
      from(schema, where: ^condition, where: ^excluding_self_condition(struct))
    end
  end

  defp siblings_with_self_condition(%schema{} = struct) do
    parent_path = Helpers.struct_path(struct)

    dynamic([q], field(q, ^schema.__hierarchy__(:path_column)) == ^parent_path)
  end

  defp excluding_self_condition(%_schema{} = struct) do
    [{pk_column, value}] = Ecto.primary_key(struct)

    dynamic([q], field(q, ^pk_column) != ^value)
  end
end
