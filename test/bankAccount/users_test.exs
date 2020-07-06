defmodule BankAccount.UsersTest do
  use BankAccount.DataCase

  alias BankAccount.Users

  import BankAccount.Factory

  describe "users" do
    alias BankAccount.Users.User

    @valid_attrs params_for(:user)
    @update_attrs %{password: "ASDFGHIJ", password_confirmation: "ASDFGHIJ"}
    @invalid_attrs %{password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      returned_user = Users.get_user!(user.id)

      assert user.id == returned_user.id
      assert user.username == returned_user.username
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.username == @valid_attrs.username
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = updated_user} = Users.update_user(user, @update_attrs)
      assert user.password_hash != updated_user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      updated_user = Users.get_user!(user.id)
      assert user.username == updated_user.username
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
