defmodule Hierarchy.Helpers do
  @moduledoc """
  Helper functions for Hierarchy.
  """

  def struct_path(%schema{} = struct) do
    Map.get(struct, schema.__hierarchy__(:path_column))
  end

  def root?(%_schema{} = struct) do
    case struct_path(struct) do
      nil -> true
      "" -> true
      _ -> false
    end
  end

  def build_child_for(%schema{} = struct, attrs \\ %{}) do
    parent_path = struct_path(struct)
    [{_pk_column, value}] = Ecto.primary_key(struct)

    path = Hierarchy.LTree.concat(parent_path, to_string(value))

    struct_attrs = Map.put(attrs, schema.__hierarchy__(:path_column), path)
    struct(schema, struct_attrs)
  end

  def build(schema, attrs) do
    struct_attrs = Map.put(attrs, schema.__hierarchy__(:path_column), "")
    struct(schema, struct_attrs)
  end
end
