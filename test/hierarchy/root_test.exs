defmodule Hierarchy.RootTest do
  use Hierarchy.DataCase

  setup_all do
    Repo.delete_all(Section)
    sections = create_sections()

    on_exit(fn ->
      Repo.delete_all(Section)
    end)

    {:ok, sections}
  end

  describe "root/1" do
    test "returns its root", sections do
      identity = Map.get(sections, "Top.Identity")
      top = Map.get(sections, "Top")

      root =
        identity
        |> Section.root()
        |> Repo.one()

      assert root == top
    end

    test "returns itself if it is the root", sections do
      top = Map.get(sections, "Top")

      root =
        top
        |> Section.root()
        |> Repo.one()

      assert root == top
    end
  end
end
