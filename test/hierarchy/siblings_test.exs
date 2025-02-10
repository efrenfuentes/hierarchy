defmodule Hierarchy.SiblingsTest do
  use Hierarchy.DataCase

  setup_all do
    sections = create_sections()

    on_exit(fn ->
      Repo.delete_all(Section)
    end)

    {:ok, sections}
  end

  describe "siblings/2" do
    test "returns its siblings", sections do
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      siblings =
        passport
        |> Section.siblings()
        |> Repo.all()

      assert_match(siblings, [pictures, others])
    end
  end

  describe "siblings/2 include_self" do
    test "returns its siblings and itself when include_self is true", sections do
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      siblings =
        passport
        |> Section.siblings(include_self: true)
        |> Repo.all()

      assert_match(siblings, [passport, pictures, others])
    end

    test "returns its siblings when include_self is false", sections do
      passport = Map.get(sections, "Top.Identity.Passport")
      pictures = Map.get(sections, "Top.Identity.Identity Pictures")
      others = Map.get(sections, "Top.Identity.Others Documents")

      siblings =
        passport
        |> Section.siblings(include_self: false)
        |> Repo.all()

      assert_match(siblings, [pictures, others])
    end
  end
end
