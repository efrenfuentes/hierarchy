defmodule Hierarchy.DescendantsTest do
  use Hierarchy.DataCase

  alias Hierarchy.Queries.Descendants

  setup_all do
    sections = create_sections()

    on_exit(fn ->
      Repo.delete_all(Section)
    end)

    {:ok, sections}
  end

  describe "descendants/2" do
    test "returns its descendants", sections do
      identity = Map.get(sections, "Top.Identity")
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      descendants =
        identity
        |> Section.descendants()
        |> Repo.all()

      assert_match(descendants, [passport, pictures, others])
    end

    test "returns blank array if it is the leaf", sections do
      others = Map.get(sections, "Top.Identity.Others Documents")

      descendants =
        others
        |> Section.descendants()
        |> Repo.all()

      assert descendants == []
    end
  end

  describe "descendants/2 with_self" do
    test "returns its descendants and itself when include_self is true", sections do
      identity = Map.get(sections, "Top.Identity")
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      descendants =
        identity
        |> Section.descendants(include_self: true)
        |> Repo.all()

      assert_match(descendants, [identity, passport, pictures, others])
    end

    test "returns its descendants when include_self is false", sections do
      identity = Map.get(sections, "Top.Identity")
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      descendants =
        identity
        |> Section.descendants(include_self: false)
        |> Repo.all()

      assert_match(descendants, [passport, pictures, others])
    end
  end

  describe "query/1" do
    import Ecto.Query

    test "returns their descendants", sections do
      identity = Map.get(sections, "Top.Identity")
      travel = Map.get(sections, "Top.International Travel")

      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      border_entry = Map.get(sections, "Top.International Travel.Border Entry")

      query =
        from(
          c in Section,
          where: c.id in ^[identity.id, travel.id]
        )

      descendants =
        query
        |> Descendants.query()
        |> Repo.all()

      assert_match(descendants, [passport, pictures, others, border_entry])
    end
  end
end
