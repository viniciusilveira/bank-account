defmodule BankAccount.Repo.Migrations.AddSelfReferenceToAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :parent_id, references(:accounts)
    end

    create index(:accounts, :parent_id)
  end
end
