defmodule BankAccount.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BankAccount.Repo

  alias BankAccount.Accounts.Account

  @doc """
  Gets a single account.

  Returns nil if the Account does not exist.

  ## Examples

      iex> get_account(1)
      %Account{}

      iex> get_account(456)
      {:error, :not_found}
  """
  def get_account(id) do
    account = Account |> Repo.get(id) |> Repo.preload([:accounts])

    case account do
      %Account{} ->
        {:ok, account}

      nil ->
        {:error, :not_found}
    end
  end

  @doc """
  Gets a single account by cpf.

  Returns nil if the Account does not exist.

  ## Examples

      iex> get_account_by_cpf("859.653.930-16")
      %Account{}

      iex> get_account_cpf(456)
      nil
  """
  def get_account_by_cpf(_cpf = nil), do: nil
  def get_account_by_cpf(cpf), do: Repo.get_by(Account, cpf_hash: cpf)

  @doc """
  Gets a single account by referral_code.

  Returns `nil` if the Account does not exist.

  ## Examples

    iex> get_sccount_by_referral_code("AJ21KKQ9")
    %Account{}

    iex> get_account_by_referral_code("1111111")
    nil
  """

  def get_account_by_referral_code(_referral_code = nil), do: nil

  def get_account_by_referral_code(referral_code),
    do: Repo.get_by(Account, referral_code: referral_code)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    status = get_status(attrs)
    attrs = Map.put(attrs, "status", status)
    referral_account = get_account_by_referral_code(attrs["referral_code"])

    with false <- is_nil(attrs["referral_code"]),
         %Account{} = referral_account <- referral_account do
      attrs
      |> Map.put("referral_code", generate_referral_code(status))
      |> do_create_account(referral_account)
    else
      true ->
        attrs
        |> Map.merge(%{"status" => status, "referral_code" => generate_referral_code(status)})
        |> do_create_account()

      _ ->
        %Account{}
        |> Account.changeset(attrs)
        |> Ecto.Changeset.add_error(:base, "Referral code is invalid")
        |> Repo.insert()
    end
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    status = get_status(attrs, account)
    attrs = Map.put(attrs, "status", status)

    referral_code =
      if account.referral_code == nil do
        generate_referral_code(status)
      end

    with false <- is_nil(attrs["referral_code"]),
         %Account{} = referral_account <- get_account_by_referral_code(attrs["referral_code"]),
         nil <- account.parent_id do
      attrs
      |> Map.put("referral_code", referral_code)
      |> do_update_account(account, referral_account)
    else
      true ->
        attrs
        |> Map.put("referral_code", referral_code)
        |> do_update_account(account)

      _ ->
        account
        |> Account.update_changeset(attrs)
        |> Ecto.Changeset.add_error(:base, "Referral code is Invalid")
        |> Repo.update()
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  defp do_create_account(attrs, referral_account \\ nil) do
    %Account{}
    |> Account.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:account, referral_account)
    |> Repo.insert()
  end

  defp do_update_account(attrs, %Account{} = account, referral_account \\ nil) do
    account
    |> Repo.preload(:account)
    |> Account.update_changeset(attrs)
    |> put_referral_account(referral_account)
    |> Repo.update()
  end

  defp put_referral_account(changeset, %Account{} = referral_account) do
    Ecto.Changeset.put_assoc(changeset, :account, referral_account)
  end

  defp put_referral_account(changeset, _referral_account), do: changeset

  defp get_status(attrs, account \\ %Account{}) do
    case Account.check_status(attrs, account).valid? do
      true -> "completed"
      false -> "pending"
    end
  end

  defp generate_referral_code(_status = "pending"), do: nil

  defp generate_referral_code(status = "completed") do
    min = String.to_integer("10000000", 36)
    max = String.to_integer("ZZZZZZZZ", 36)

    referral_code =
      max
      |> Kernel.-(min)
      |> :rand.uniform()
      |> Kernel.+(min)
      |> Integer.to_string(36)

    case get_account_by_referral_code(referral_code) do
      nil -> referral_code
      _ -> generate_referral_code(status)
    end
  end
end
