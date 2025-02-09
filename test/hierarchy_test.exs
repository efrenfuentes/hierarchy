defmodule HierarchyTest do
  use Hierarchy.DataCase

  doctest Hierarchy

  describe "root?/1" do
    test "returns true if it is root" do
      section = %Section{name: "", path: ""}
      assert Section.root?(section)
    end

    test "returns false if it isnt root" do
      section = %Section{name: "Identity", path: "Top.Identity"}
      refute Section.root?(section)
    end
  end

  describe "build_child_of/2" do
    test "builds a child" do
      parent = %Section{name: "Top", path: ""} |> Repo.insert!()
      section = Section.build_child_for(parent, %{name: "Identity"})

      assert section.path == parent.id
    end

    test "builds a child of the root" do
      parent = %Section{name: "Top", path: nil} |> Repo.insert!()
      section = Section.build_child_for(parent, %{name: "Identity"})

      assert section.path == parent.id
    end

    test "builds a root" do
      section = Section.build(%{name: "Identity"})

      assert section.path == ""
    end
  end
end
