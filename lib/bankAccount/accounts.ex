defmodule BankAccount.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BankAccount.Repo

  alias BankAccount.Accounts.Account

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
  Gets a single account by referal_code.

  Returns `nil` if the Account does not exist.

  ## Examples

    iex> get_sccount_by_referal_code("AJ21KKQ9")
    %Account{}

    iex> get_account_by_referal_code("1111111")
    nil
  """
  def get_account_by_referal_code(referal_code),
    do: Repo.get_by(Account, referal_code: referal_code)

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
    referal_code = generate_referal_code(status)

    %Account{}
    |> Account.changeset(Map.merge(attrs, %{"status" => status, "referal_code" => referal_code}))
    |> Repo.insert()
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
    generated_attrs = %{"status" => status}

    generated_attrs =
      if account.referal_code == nil do
        Map.merge(generated_attrs, %{"referal_code" => generate_referal_code(status)})
      else
        generated_attrs
      end

    account
    |> Account.update_changeset(Map.merge(attrs, generated_attrs))
    |> Repo.update()
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

  defp get_status(attrs, account \\ %Account{}) do
    case Account.check_status(attrs, account).valid? do
      true -> "completed"
      false -> "pending"
    end
  end

  defp generate_referal_code(_status = "pending"), do: nil

  defp generate_referal_code(status = "completed") do
    min = String.to_integer("10000000", 36)
    max = String.to_integer("ZZZZZZZZ", 36)

    referal_code =
      max
      |> Kernel.-(min)
      |> :rand.uniform()
      |> Kernel.+(min)
      |> Integer.to_string(36)

    case get_account_by_referal_code(referal_code) do
      nil -> referal_code
      _ -> generate_referal_code(status)
    end
  end
end
