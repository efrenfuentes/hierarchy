defmodule Hierarchy.Queries.Children do
  @moduledoc """
  Children query expressions
  """
  import Ecto.Query

  alias Hierarchy.{Helpers, LTree}

  @doc """
  Return query expressions for children of a query

  ```elixir
  import Ecto.Query

  query = from t in Section, where: [..]

  query
  |> Hierarchy.Queries.Children.query()
  |> Repo.all
  """
  def query(%{from: %{source: {_table_name, schema}}} = queryable) do
    path_column = schema.__hierarchy__(:path_column)

    [pk_column] = schema.__schema__(:primary_key)

    uuids_query =
      from(t in queryable,
        select: %{
          __ancestry__:
            fragment(
              "? || replace(text(?), '-', '_')",
              field(t, ^path_column),
              field(t, ^pk_column)
            )
        }
      )

    uuids_array_query =
      from(t in subquery(uuids_query),
        select: %{__ltrees__: fragment("array_agg(?)", t.__ancestry__)}
      )

    schema
    |> join(:cross, [], a in subquery(uuids_array_query))
    |> where([t, a], field(t, ^path_column) in a.__ltrees__)
  end

  @doc """
  Return query expressions for children
  ## Options

    * `:include_self` - when true to include itself. Defaults to false.

  ```elixir
  %Section{
    id: "06a84054-8827-42c2-9b75-25ed75e6d5f8",
    name: "Top.Identity",
    path: "a9ae8f40-b016-4bf9-8224-e2755466e699",
  }
  |> Section.children()
  |> Repo.all
  ```
  """
  def query(%schema{} = struct, opts \\ []) do
    children_condition = children_condition(struct)

    if Keyword.get(opts, :include_self, false) do
      from(schema, where: ^children_condition, or_where: ^including_self_condition(struct))
    else
      from(schema, where: ^children_condition)
    end
  end

  defp children_condition(%schema{} = struct) do
    path = Helpers.struct_path(struct)
    [{_pk_column, value}] = Ecto.primary_key(struct)

    children_path = LTree.concat(path, value)

    dynamic([q], field(q, ^schema.__hierarchy__(:path_column)) == ^children_path)
  end

  defp including_self_condition(%_schema{} = struct) do
    [{pk_column, value}] = Ecto.primary_key(struct)

    dynamic([q], field(q, ^pk_column) == ^value)
  end
end
