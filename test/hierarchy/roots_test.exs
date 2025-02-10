defmodule Hierarch.RootsTest do
  use Hierarchy.DataCase

  setup_all do
    sections = create_sections()

    on_exit(fn ->
      Repo.delete_all(Section)
    end)

    {:ok, sections}
  end

  describe "roots/0" do
    test "returns its roots", sections do
      top = Map.get(sections, "Top")
      other_top = Section.build(%{name: "OtherTop"}) |> Repo.insert!()

      roots =
        Section.roots()
        |> Repo.all()

      assert roots == [top, other_top]
    end
  end
end
