defmodule Hierarchy.Ecto.LTree do
  @moduledoc """
  LTree type for Ecto.
  """
  use Ecto.Type

  def type, do: :ltree

  @doc false
  def cast(label), do: {:ok, label}

  @doc false
  def dump(label), do: {:ok, to_string(label)}

  @doc false
  def load(label), do: {:ok, label}
end
