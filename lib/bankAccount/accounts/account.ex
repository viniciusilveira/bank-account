defmodule BankAccount.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Brcpfcnpj.Changeset

  use Timex

  @required_fields ~w(cpf)a
  @optional_fields ~w(birth_date city country email gender name referal_code state)a

  schema "accounts" do
    field :birth_date, BankAccount.Encrypted.Binary
    field :city, :binary
    field :country, :binary
    field :cpf, BankAccount.Encrypted.Binary
    field :cpf_hash, Cloak.Ecto.SHA256
    field :email, BankAccount.Encrypted.Binary
    field :gender, :binary
    field :name, BankAccount.Encrypted.Binary
    field :referal_code, :binary
    field :state, :binary

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_cpf(:cpf)
    |> validate_date(:birth_date)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:referal_code, is: 8)
    |> unique_constraint(:cpf)
    |> put_hashed_fields()
  end

  def update_changeset(account, attrs) do
    account
    |> cast(attrs, @optional_fields)
    |> be_updated?(attrs)
    |> validate_date(:birth_date)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:referal_code, is: 8)
  end

  defp be_updated?(changeset, attrs) do
    case changeset.valid? do
      true ->
        case Map.has_key?(attrs, :cpf) do
          false -> changeset
          true -> add_error(changeset, :cpf, "Cannot be updated")
        end

      _ ->
        changeset
    end
  end

  defp validate_date(changeset, field) do
    case changeset.valid? do
      true ->
        birth_date = get_field(changeset, field)

        case Timex.parse(birth_date, "{0D}/{0M}/{YYYY}") do
          {:ok, _} -> changeset
          _ -> add_error(changeset, :date, "Format invalid")
        end

      _ ->
        changeset
    end
  end

  defp put_hashed_fields(changeset) do
    changeset
    |> put_change(:cpf_hash, get_field(changeset, :cpf))
  end
end