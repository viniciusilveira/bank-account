defmodule BankAccount.AccountsTest do
  use BankAccount.DataCase

  alias Brcpfcnpj
  alias BankAccount.Accounts

  import BankAccount.Factory

  describe "accounts" do
    alias BankAccount.Accounts.Account

    @valid_attrs string_params_for(:account)
    @update_attrs Map.delete(string_params_for(:account), "cpf")
    @invalid_attrs string_params_for(:account_invalid)
    setup do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      {:ok, account: account}
    end

    test "get_account/1 returns the account", %{account: account} do
      returnedAccount = Accounts.get_account(account.id)

      assert account.birth_date == returnedAccount.birth_date
      assert account.city == returnedAccount.city
      assert account.country == returnedAccount.country
      assert account.cpf == returnedAccount.cpf
      assert account.email == returnedAccount.email
      assert account.gender == returnedAccount.gender
      assert account.name == returnedAccount.name
      assert account.referral_code == returnedAccount.referral_code
      assert account.state == returnedAccount.state
    end

    test "get_account/1 returns nil when id not exits" do
      assert nil == Accounts.get_account(12_315_324)
    end

    test "get_account_by_cpf/1 returns the account with given cpf", %{account: account} do
      returnedAccount = Accounts.get_account_by_cpf(account.cpf)

      assert account.birth_date == returnedAccount.birth_date
      assert account.city == returnedAccount.city
      assert account.country == returnedAccount.country
      assert account.cpf == returnedAccount.cpf
      assert account.email == returnedAccount.email
      assert account.gender == returnedAccount.gender
      assert account.name == returnedAccount.name
      assert account.referral_code == returnedAccount.referral_code
      assert account.state == returnedAccount.state
    end

    test "get_account_by_cpf/1 returns nil when cpf does not exist in database" do
      assert nil == Accounts.get_account_by_cpf(Brcpfcnpj.cpf_generate(true))
    end

    test "get_account_by_referral_code/1 returns the account with given cpf" do
      account = insert(:account, referral_code: "12345678")
      returnedAccount = Accounts.get_account_by_referral_code(account.referral_code)

      assert account.birth_date == returnedAccount.birth_date
      assert account.city == returnedAccount.city
      assert account.country == returnedAccount.country
      assert account.cpf == returnedAccount.cpf
      assert account.email == returnedAccount.email
      assert account.gender == returnedAccount.gender
      assert account.name == returnedAccount.name
      assert account.referral_code == returnedAccount.referral_code
      assert account.state == returnedAccount.state
    end

    test "get_account_by_referral_code/1 returns nil when cpf does not exist in database" do
      insert(:account, referral_code: "12345678")
      assert nil == Accounts.get_account_by_referral_code("11111111")
    end

    test "create_account/1 with valid data creates a account", %{account: account} do
      assert account.birth_date == @valid_attrs["birth_date"]
      assert account.city == @valid_attrs["city"]
      assert account.country == @valid_attrs["country"]
      assert account.cpf == @valid_attrs["cpf"]
      assert account.email == @valid_attrs["email"]
      assert account.gender == @valid_attrs["gender"]
      assert account.name == @valid_attrs["name"]
      assert account.state == @valid_attrs["state"]
    end

    test "create_account/1 with valid data and referral_code creates a account", %{
      account: referrer_account
    } do
      {:ok, account} =
        Accounts.create_account(
          string_params_for(:account, referral_code: referrer_account.referral_code)
        )

      assert account.parent_id === referrer_account.id
    end

    test "create_account/1 with invalid referral_code and returs error changeset", %{
      account: _referrer_account
    } do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_account(string_params_for(:account, referral_code: "12345678"))
    end

    test "create_account/1 with invalid cpf and returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_account(string_params_for(:account, cpf: "859.653.930-17"))
    end

    test "create_account/1 with invalid email and returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_account(string_params_for(:account, email: "invalidemail.com"))
    end

    test "create_account/1 with invalid birth_date and returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_account(string_params_for(:account, birth_date: "31/02/1915"))
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account", %{account: account} do
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)

      assert account.birth_date == @update_attrs["birth_date"]
      assert account.city == @update_attrs["city"]
      assert account.country == @update_attrs["country"]
      assert account.email == @update_attrs["email"]
      assert account.gender == @update_attrs["gender"]
      assert account.name == @update_attrs["name"]
      assert account.state == @update_attrs["state"]
    end

    test "update_account/1 with valid data and referral_code creates a account", %{
      account: referrer_account
    } do
      {:ok, account} = Accounts.create_account(string_params_for(:account, email: nil))

      assert account.status == "pending"

      assert {:ok, account} =
               Accounts.update_account(account, %{
                 "referral_code" => referrer_account.referral_code
               })

      assert account.parent_id == referrer_account.id
    end

    test "update_account/1 with invalid referral_code returns error changeset", %{
      account: _referrer_account
    } do
      {:ok, account} = Accounts.create_account(string_params_for(:account, email: nil))

      assert account.status == "pending"

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_account(account, %{
                 "referral_code" => "12345678"
               })
    end

    test "update_account/2 with invalid email returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_account(
                 account,
                 string_params_for(:account, email: "invalidemail.com")
               )
    end

    test "update_account/2 with invalid birth_date returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_account(
                 account,
                 string_params_for(:account, birth_date: "12/15/2030")
               )
    end

    test "change_account/1 returns a account changeset", %{account: account} do
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
