defmodule Hierarchy.ParentTest do
  use Hierarchy.DataCase

  setup_all do
    Repo.delete_all(Section)
    sections = create_sections()

    on_exit(fn ->
      Repo.delete_all(Section)
    end)

    {:ok, sections}
  end

  describe "parent/1" do
    test "returns its parent", sections do
      border_entry = Map.get(sections, "Top.International Travel.Border Entry")
      top = Map.get(sections, "Top.International Travel")

      parent =
        border_entry
        |> Section.parent()
        |> Repo.one()

      assert parent == top
    end

    test "returns nil if it is the root", sections do
      top = Map.get(sections, "Top")

      parent =
        top
        |> Section.parent()
        |> Repo.one()

      assert is_nil(parent)
    end
  end
end
