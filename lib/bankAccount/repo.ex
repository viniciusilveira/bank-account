defmodule BankAccount.Repo do
  use Ecto.Repo,
    otp_app: :bankAccount,
    adapter: Ecto.Adapters.Postgres
end
