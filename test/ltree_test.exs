defmodule Hierarchy.LtreeTest do
  use Hierarchy.DataCase

  alias Hierarchy.LTree

  doctest LTree

  describe "parent_id/2" do
    test "returns parent_id" do
      parent_id = LTree.parent_id("Top.Identity")
      assert parent_id == "Identity"
    end

    test "returns nil for the root" do
      parent_id = LTree.parent_id("")
      assert parent_id == nil
    end

    test "returns nil for the root without path" do
      parent_id = LTree.parent_id(nil)
      assert parent_id == nil
    end
  end

  describe "parent_path/1" do
    test "returns the parent_path" do
      assert LTree.parent_path("Top.International Travel.Border Entry") ==
               "Top.International Travel"
    end

    test "returns blank string" do
      assert LTree.parent_path("Top") == nil
    end
  end

  describe "root/2" do
    test "returns root_id" do
      root_id = LTree.root_id("Top.International Travel", "Border Entry")
      assert root_id == "Top"
    end

    test "returns itself if it is the root" do
      root_id = LTree.root_id("", "Top")
      assert root_id == "Top"
    end
  end

  describe "split/1" do
    test "works" do
      assert [] == LTree.split(nil)
      assert [] == LTree.split("")
      assert ["Top", "Identity"] == LTree.split("Top.Identity")
    end
  end

  describe "concat/1" do
    test "works" do
      assert nil == LTree.concat(nil, nil)
      assert nil == LTree.concat(nil, "")
      assert "Top.Identity" == LTree.concat("Top.Identity", nil)
      assert "Identity.Passport" = LTree.concat("Identity", "Passport")
    end
  end
end
