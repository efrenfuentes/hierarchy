defmodule Hierarchy.Repo.Migrations.AddSectionsTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS ltree" # Enables Ltree

    create table(:sections) do
      add :id, :uuid, primary_key: true

      add :name, :string
      add :path, :ltree

      timestamps()
    end

    create index(:sections, [:path], using: "GIST")
  end
end
