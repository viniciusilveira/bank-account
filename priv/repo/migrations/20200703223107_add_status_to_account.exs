defmodule BankAccount.Repo.Migrations.AddStatusToAccount do
  use Ecto.Migration

  def change do
    alter table("accounts") do
      add :status, :string
    end
  end
end
