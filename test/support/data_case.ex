defmodule Hierarchy.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.
  """

  alias Ecto.Adapters.SQL.Sandbox
  alias ForTesting.Section

  use ExUnit.CaseTemplate

  using(opts) do
    quote do
      use ExUnit.Case, unquote(opts)
      alias ForTesting.{Repo, Section}

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Hierarchy.DataCase

      def create_sections do
        [
          "Top",
          "Top.Identity",
          "Top.Identity.Passport",
          "Top.Identity.Identity Pictures",
          "Top.International Travel",
          "Top.International Travel.Border Entry"
        ]
        |> Enum.reduce(%{}, fn name, acc ->
          parent_name = Hierarchy.LTree.parent_path(name)
          parent = Map.get(acc, parent_name, nil)

          section =
            case parent do
              nil ->
                Section.build(%{name: name}) |> Repo.insert!()

              parent ->
                Section.build_child_for(parent, %{name: name}) |> Repo.insert!()
            end

          Map.put(acc, name, section)
        end)
      end
    end
  end

  setup do
    Sandbox.mode(ForTesting.Repo, {:shared, self()})
    :ok = Sandbox.checkout(ForTesting.Repo)
  end
end
