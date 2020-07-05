defmodule BankAccountWeb.AccountControllerTest do
  use BankAccountWeb.ConnCase

  alias BankAccount.Accounts

  import BankAccount.Factory

  @create_attrs string_params_for(:account)
  @incomplete_attrs string_params_for(:account, email: nil)
  @invalid_attrs %{
    birth_date: nil,
    city: nil,
    country: nil,
    cpf: nil,
    email: nil,
    gender: nil,
    name: nil,
    referral_code: nil,
    state: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid and all fields were informed ", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      response_account = json_response(conn, 200)["data"]
      assert response_account["birth_date"] == @create_attrs["birth_date"]
      assert response_account["city"] == @create_attrs["city"]
      assert response_account["country"] == @create_attrs["country"]
      assert response_account["cpf"] == @create_attrs["cpf"]
      assert response_account["email"] == @create_attrs["email"]
      assert response_account["gender"] == @create_attrs["gender"]
      assert response_account["name"] == @create_attrs["name"]
      assert response_account["state"] == @create_attrs["state"]
      assert response_account["status"] == "completed"
      assert response_account["referral_code"] !== nil
    end

    test "renders account when data is valid and fields are incompleted ", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @incomplete_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      response_account = json_response(conn, 200)["data"]
      assert response_account["birth_date"] == @incomplete_attrs["birth_date"]
      assert response_account["city"] == @incomplete_attrs["city"]
      assert response_account["country"] == @incomplete_attrs["country"]
      assert response_account["cpf"] == @incomplete_attrs["cpf"]
      assert response_account["gender"] == @incomplete_attrs["gender"]
      assert response_account["name"] == @incomplete_attrs["name"]
      assert response_account["state"] == @incomplete_attrs["state"]
      assert response_account["status"] == "pending"
      assert response_account["referral_code"] == nil
    end

    test "renders account when data is valid and referral_code was informed", %{conn: conn} do
      {:ok, account} = Accounts.create_account(@create_attrs)
      attrs_with_referral = string_params_for(:account, referral_code: account.referral_code)

      conn = post(conn, Routes.account_path(conn, :create), account: attrs_with_referral)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      response_account = json_response(conn, 200)["data"]

      assert response_account["birth_date"] == attrs_with_referral["birth_date"]
      assert response_account["city"] == attrs_with_referral["city"]
      assert response_account["country"] == attrs_with_referral["country"]
      assert response_account["cpf"] == attrs_with_referral["cpf"]
      assert response_account["gender"] == attrs_with_referral["gender"]
      assert response_account["name"] == attrs_with_referral["name"]
      assert response_account["state"] == attrs_with_referral["state"]
      assert response_account["status"] == "completed"
      assert response_account["referral_code"] != nil
    end

    test "update account when incompleted data", %{conn: conn} do
      Accounts.create_account(@incomplete_attrs)

      conn =
        post(conn, Routes.account_path(conn, :create),
          account: %{cpf: @incomplete_attrs["cpf"], name: "Marcos Vinicius"}
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      response_account = json_response(conn, 200)["data"]
      assert response_account["birth_date"] == @incomplete_attrs["birth_date"]
      assert response_account["city"] == @incomplete_attrs["city"]
      assert response_account["country"] == @incomplete_attrs["country"]
      assert response_account["cpf"] == @incomplete_attrs["cpf"]
      assert response_account["gender"] == @incomplete_attrs["gender"]
      assert response_account["name"] == "Marcos Vinicius"
      assert response_account["state"] == @incomplete_attrs["state"]
      assert response_account["status"] == "pending"
      assert response_account["referral_code"] == nil
    end

    test "update account when data is valid and referral_code was informed", %{conn: conn} do
      {:ok, referrer_account} = Accounts.create_account(@create_attrs)
      {:ok, account} = Accounts.create_account(@incomplete_attrs)

      attrs_with_referral = %{
        cpf: account.cpf,
        referral_code: referrer_account.referral_code,
        email: "teste@mail.com"
      }

      conn = post(conn, Routes.account_path(conn, :create), account: attrs_with_referral)

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_path(conn, :show, id))

      response_account = json_response(conn, 200)["data"]

      assert response_account["birth_date"] == account.birth_date
      assert response_account["city"] == account.city
      assert response_account["country"] == account.country
      assert response_account["cpf"] == account.cpf
      assert response_account["gender"] == account.gender
      assert response_account["name"] == account.name
      assert response_account["state"] == account.state
      assert response_account["email"] == attrs_with_referral.email
      assert response_account["status"] == "completed"
      assert response_account["referral_code"] != nil
    end

    test "renders errors when cpf is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_path(conn, :create),
          account: string_params_for(:account, cpf: "315.694.100-04")
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_path(conn, :create),
          account: string_params_for(:account, email: "invalidmail.com")
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when birth_date is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_path(conn, :create),
          account: string_params_for(:account, birth_date: "12/11/2019d")
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show account" do
    test "renders account", %{conn: conn} do
      {:ok, account} = Accounts.create_account(@create_attrs)
      conn = get(conn, Routes.account_path(conn, :show, account.id))
      response_account = json_response(conn, 200)["data"]
      assert response_account["birth_date"] == @create_attrs["birth_date"]
      assert response_account["city"] == @create_attrs["city"]
      assert response_account["country"] == @create_attrs["country"]
      assert response_account["cpf"] == @create_attrs["cpf"]
      assert response_account["email"] == @create_attrs["email"]
      assert response_account["gender"] == @create_attrs["gender"]
      assert response_account["name"] == @create_attrs["name"]
      assert response_account["state"] == @create_attrs["state"]
      assert response_account["status"] == "completed"
    end

    test "renders error when id doesn't exist", %{conn: conn} do
      {:ok, _account} = Accounts.create_account(@create_attrs)
      conn = get(conn, Routes.account_path(conn, :show, 12391))
      assert json_response(conn, 200)["data"] == nil
    end
  end
end
