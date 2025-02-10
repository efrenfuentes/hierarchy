defmodule Hierarchy.ChildrenTest do
  use Hierarchy.DataCase

  alias Hierarchy.Queries.Children

  setup_all do
    sections = create_sections()

    on_exit(fn ->
      Repo.delete_all(Section)
    end)

    {:ok, sections}
  end

  describe "children/2" do
    test "returns its children", sections do
      identity = Map.get(sections, "Top.Identity")
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      children =
        identity
        |> Section.children()
        |> Repo.all()

      assert children == [passport, pictures, others]
    end

    test "returns blank array if it is the leaf", sections do
      passport = Map.get(sections, "Top.Identity.Passport")

      children =
        passport
        |> Section.children()
        |> Repo.all()

      assert children == []
    end
  end

  describe "children/2 include_self" do
    test "returns its children and itself when with_self is true", sections do
      identity = Map.get(sections, "Top.Identity")
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      children =
        identity
        |> Section.children(include_self: true)
        |> Repo.all()

      assert_match(children, [identity, passport, pictures, others])
    end

    test "returns its children when with_self is false", sections do
      identity = Map.get(sections, "Top.Identity")
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      children =
        identity
        |> Section.children(include_self: false)
        |> Repo.all()

      assert children == [passport, pictures, others]
    end
  end

  describe "children/1" do
    import Ecto.Query

    test "returns children of a query", sections do
      identity = Map.get(sections, "Top.Identity")
      international_travel = Map.get(sections, "Top.International Travel")
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")
      border_entry = Map.get(sections, "Top.International Travel.Border Entry")

      query =
        from(
          c in Section,
          where: c.id in ^[identity.id, international_travel.id]
        )

      descendants =
        query
        |> Children.query()
        |> Repo.all()

      assert_match(descendants, [passport, pictures, others, border_entry])
    end
  end
end
