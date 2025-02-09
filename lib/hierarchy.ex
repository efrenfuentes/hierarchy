defmodule Hierarchy do
  @moduledoc """
  Using `Hierarchy` will add hierarchical functions to your Ecto model.

  ## Examples

      defmodule Section do
        use Ecto.Schema
        use Hierarchy

        @primary_key {:id, :binary_id, autogenerate: true}

        schema "categories" do
          field :name, :string
          field :path, Hierarch.Ecto.UUIDLTree

          timestamps()
        end
      end
  """

  defmacro __using__(opts) do
    path_column = Keyword.get(opts, :path_column, :path)

    quote do
      def __hierarchy__(:path_column) do
        unquote(path_column)
      end

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(%{module: schema}) do
    quote do
      # utils
      defdelegate root?(struct), to: Hierarchy.Helpers
      defdelegate build_child_for(struct, attrs \\ %{}), to: Hierarchy.Helpers

      def build(attrs) do
        Hierarchy.Helpers.build(unquote(schema), attrs)
      end
    end
  end
end
