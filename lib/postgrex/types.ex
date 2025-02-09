Postgrex.Types.define(
  Hierarchy.Postgrex.Types,
  [
    Hierarchy.Postgrex.Extensions.LTree,
    Hierarchy.Postgrex.Extensions.LQuery
  ] ++ Ecto.Adapters.Postgres.extensions()
)
