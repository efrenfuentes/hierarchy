# Hierarchy

Hierarchy helps to build a hierarchy tree using Ecto models

## Installation

The package can be installed by adding `hierarchy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hierarchy, "~> 0.1.0"}
  ]
end
```

Enable ltree extension:

```elixir
execute "CREATE EXTENSION IF NOT EXISTS ltree"
```

Add GIST index:

```elixir
create index(:catelogs, [:path], using: "GIST")
```

## Example

### Set `types` at config/config.exs or your environment config file

```elixir
config :my_app, MyApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: Hierarchy.Postgrex.Types
```

### Write a migration for this functionality

```elixir
defmodule MyApp.Repo.Migrations.AddSectionsTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS ltree" # Enables Ltree action

    create table(:sections, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :path, :ltree

      timestamps()
    end

    create index(:sections, [:path], using: "GIST") # Add GIST index to query
  end
end
```

### Use Hierarchy in your schema

Options:

- path_column (default: `:path`): the name of the database column which stores hierarchy data;

```elixir
defmodule MyApp.Section do
  use Ecto.Schema
  use Hierarchy

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "sections" do
    field :name, :string
    field :path, Hierarchy.Ecto.UUIDLTree # Set to `UUIDLTree` if the path is ltree type

    timestamps()
  end
end
```

## Usage

### `build_child_for/2`

Take the parent struct and attributes struct, return a child struct.

```elixir
parent = %Section{
  id: "570526aa-e2f3-49a7-870a-c150d3bf6ac9",
  name: "Top",
  path: ""
}

section = Section.build_child_for(parent, %{name: "Top.Identity"})
#  %Section{
#    id: nil,
#    name: "Top.Identity",
#    path: "570526aa-e2f3-49a7-870a-c150d3bf6ac9"
#  }
```

### `root?/1`

Detect a struct whether a root.

```elixir
catelog = %Section{
  id: "570526aa-e2f3-49a7-870a-c150d3bf6ac9",
  name: "Top",
  path: ""
}

Section.root?(section) # true
```

### `parent/1`

Return the parent query expression of the given struct, return `nil` if it is the root.

```elixir
section = %Section{
  id: "570526aa-e2f3-49a7-870a-c150d3bf6ac9",
  name: "Top",
  path: ""
}

Section.parent(section) |> Repo.one # nil
```

### `root/1`

Return the root query expression of the given struct, return itself if it is the root.

```elixir
section = %Section{
  id: "570526aa-e2f3-49a7-870a-c150d3bf6ac9",
  name: "Top",
  path: ""
}

Section.root(section) |> Repo.one # return itself `section`
```

### `ancestors/2`

Return the ancestors query expression of the given struct.

Options:

- `:include_self` - when true to include itself. Defaults to false

```elixir
section = %Section{
  id: "06a84054-8827-42c2-9b75-25ed75e6d5f8",
  name: "Top.Identity",
  path: "a9ae8f40-b016-4bf9-8224-e2755466e699",
}

Section.ancestors(section) |> Repo.all
#  [%Section{
#    id: "a9ae8f40-b016-4bf9-8224-e2755466e699",
#    name: "Top",
#    path: ""
#  }]

Section.ancestors(catelog, include_self: true) |> Repo.all
#  [
#    %Section{
#      id: "a9ae8f40-b016-4bf9-8224-e2755466e699",
#      name: "Top",
#      path: ""
#    },
#    %Section{
#      id: "06a84054-8827-42c2-9b75-25ed75e6d5f8",
#      name: "Top.Identity",
#      path: "a9ae8f40-b016-4bf9-8224-e2755466e699"
#    }
#  ]

```

### `descendants/2`

Return the descendants query expression of the given struct.
Options:

- `:include_self` - when true to include itself. Defaults to false

```elixir
section = %Section{
  id: "06a84054-8827-42c2-9b75-25ed75e6d5f8",
  name: "Top.Identity",
  path: "a9ae8f40-b016-4bf9-8224-e2755466e699",
}

Section.descendants(section) |> Repo.all
#  [
#    %Section{
#      id: "6ff8db2e-5c01-4e82-a25b-4c1568df1efb",
#      name: "Top.Identity.Passport",
#      path: "a9ae8f40-b016-4bf9-8224-e2755466e699.06a84054-8827-42c2-9b75-25ed75e6d5f8"
#    }
#  ]
```

### `siblings/2`

Return the siblings query expression of the given struct.
Options:

- `:include_self` - when true to include itself. Defaults to false

```elixir
section = %Section{
  id: "06a84054-8827-42c2-9b75-25ed75e6d5f8",
  name: "Top.Identity",
  path: "a9ae8f40-b016-4bf9-8224-e2755466e699",
}

Section.siblings(section) |> Repo.all
#  [
#    %Sections{
#      id: "6c11f83f-3c3c-44bf-9940-8153c1f04de9",
#      name: "Top.International Travel",
#      path: "a9ae8f40-b016-4bf9-8224-e2755466e699"
#    },
#    %Section{
#      id: "570526aa-e2f3-49a7-870a-c150d3bf6ac9",
#      name: "Top.Business",
#      path: "a9ae8f40-b016-4bf9-8224-e2755466e699"
#    }
#  ]
```

### `roots/0`

Return the roots query expression.

```elixir
Section.roots() |> Repo.all
#  [
#    %Section{
#      id: "a9ae8f40-b016-4bf9-8224-e2755466e699",
#      name: "Top",
#      path: ""
#    }
#  ]
```
