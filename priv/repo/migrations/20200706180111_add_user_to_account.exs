defmodule BankAccount.Repo.Migrations.AddUserToAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :user_id, references(:users)
    end

    create index(:accounts, :user_id)
  end
end
