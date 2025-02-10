defmodule Hierarchy.AncestorsTest do
  use Hierarchy.DataCase

  alias Hierarchy.Queries.Ancestors

  setup_all do
    sections = create_sections()

    on_exit(fn ->
      Repo.delete_all(Section)
    end)

    {:ok, sections}
  end

  describe "ancestors/2" do
    test "returns its ancestors", sections do
      top = Map.get(sections, "Top")
      identity = Map.get(sections, "Top.Identity")
      passport = Map.get(sections, "Top.Identity.Passport")

      ancestors =
        passport
        |> Section.ancestors()
        |> Repo.all()

      assert ancestors == [top, identity]
    end

    test "returns blank array if it is the root", sections do
      top = Map.get(sections, "Top")

      ancestors =
        top
        |> Section.ancestors()
        |> Repo.all()

      assert ancestors == []
    end
  end

  describe "ancestors/2 include_self" do
    test "returns its ancestors and itself", sections do
      top = Map.get(sections, "Top")
      identity = Map.get(sections, "Top.Identity")
      passport = Map.get(sections, "Top.Identity.Passport")

      ancestors =
        passport
        |> Section.ancestors(include_self: true)
        |> Repo.all()

      assert ancestors == [top, identity, passport]
    end

    test "returns itself if it is the root", sections do
      top = Map.get(sections, "Top")

      ancestors =
        top
        |> Section.ancestors(include_self: true)
        |> Repo.all()

      assert ancestors == [top]
    end
  end

  describe "ancestors/1" do
    import Ecto.Query

    test "returns ancestors of a query", sections do
      identity = Map.get(sections, "Top.Identity")
      international_travel = Map.get(sections, "Top.International Travel")
      others = Map.get(sections, "Top.Identity.Others Documents")

      top = Map.get(sections, "Top")

      query =
        from(
          c in Section,
          where: c.id in ^[identity.id, international_travel.id, others.id]
        )

      descendants =
        query
        |> Ancestors.query()
        |> Repo.all()

      assert_match(descendants, [top, identity])
    end
  end
end
