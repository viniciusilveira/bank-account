ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BankAccount.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
