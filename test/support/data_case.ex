defmodule Hierarchy.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.
  """

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
        section_list = [
          "Top",
          "Top.Identity",
          "Top.Identity.Passport",
          "Top.Identity.Identity Pictures",
          "Top.International Travel",
          "Top.International Travel.Border Entry"
        ]
      end
    end
  end

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(ForTesting.Repo, {:shared, self()})
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ForTesting.Repo)
  end
end
