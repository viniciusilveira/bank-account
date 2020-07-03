defmodule BankAccount.AccountsTest do
  use BankAccount.DataCase

  alias BankAccount.Accounts

  import BankAccount.Factory

  describe "accounts" do
    alias BankAccount.Accounts.Account

    @valid_attrs params_for(:account)
    @update_attrs Map.delete(params_for(:account), :cpf)
    @invalid_attrs %{
      birth_date: nil,
      city: nil,
      country: nil,
      cpf: nil,
      email: nil,
      gender: nil,
      name: nil,
      referal_code: nil,
      state: nil
    }

    setup do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      {:ok, account: account}
    end

    test "get_account_by/1 returns the account with given cpf", %{account: account} do
      returnedAccount = Accounts.get_account_by(account.cpf)

      assert account.birth_date == returnedAccount.birth_date
      assert account.city == returnedAccount.city
      assert account.country == returnedAccount.country
      assert account.cpf == returnedAccount.cpf
      assert account.email == returnedAccount.email
      assert account.gender == returnedAccount.gender
      assert account.name == returnedAccount.name
      assert account.referal_code == returnedAccount.referal_code
      assert account.state == returnedAccount.state
    end

    test "create_account/1 with valid data creates a account", %{account: account} do
      assert account.birth_date == @valid_attrs.birth_date
      assert account.city == @valid_attrs.city
      assert account.country == @valid_attrs.country
      assert account.cpf == @valid_attrs.cpf
      assert account.email == @valid_attrs.email
      assert account.gender == @valid_attrs.gender
      assert account.name == @valid_attrs.name
      assert account.referal_code == @valid_attrs.referal_code
      assert account.state == @valid_attrs.state
    end

    test "create_account/1 with invalid cpf and returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_account(params_for(:account, cpf: "859.653.930-17"))
    end

    test "create_account/1 with invalid email and returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_account(params_for(:account, email: "invalidemail.com"))
    end

    test "create_account/1 with invalid birth_date and returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_account(params_for(:account, birth_date: "31/02/1915"))
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account", %{account: account} do
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)

      assert account.birth_date == @update_attrs.birth_date
      assert account.city == @update_attrs.city
      assert account.country == @update_attrs.country
      assert account.email == @update_attrs.email
      assert account.gender == @update_attrs.gender
      assert account.name == @update_attrs.name
      assert account.referal_code == @update_attrs.referal_code
      assert account.state == @update_attrs.state
    end

    test "update_account/2 with invalid data returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      returnedAccount = Accounts.get_account_by(account.cpf)

      assert account.birth_date == returnedAccount.birth_date
      assert account.city == returnedAccount.city
      assert account.country == returnedAccount.country
      assert account.cpf == returnedAccount.cpf
      assert account.email == returnedAccount.email
      assert account.gender == returnedAccount.gender
      assert account.name == returnedAccount.name
      assert account.referal_code == returnedAccount.referal_code
      assert account.state == returnedAccount.state
    end

    test "update_account/2 with cpf returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, params_for(:account))
    end

    test "update_account/2 with invalid email returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_account(account, params_for(:account, email: "invalidemail.com"))
    end

    test "update_account/2 with invalid birth_date returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_account(account, params_for(:account, birth_date: "12/15/2030"))
    end

    test "change_account/1 returns a account changeset", %{account: account} do
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
