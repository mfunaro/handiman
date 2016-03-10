ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Handiman.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Handiman.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Handiman.Repo)

