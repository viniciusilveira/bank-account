defmodule BankAccount.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :binary
      add :email, :binary
      add :cpf, :binary
      add :cpf_hash, :binary
      add :birth_date, :binary
      add :gender, :binary
      add :city, :binary
      add :state, :binary
      add :country, :binary
      add :referral_code, :binary

      timestamps()
    end

    create unique_index(:accounts, [:cpf])
  end
end
