defmodule BankAccount.Factory do
  use ExMachina.Ecto, repo: BankAccount.Repo

  use BankAccount.{
    AccountFactory
  }
end
