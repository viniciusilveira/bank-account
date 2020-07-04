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
    referal_code: nil,
    state: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid and all fields were informed ", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @create_attrs)
      assert %{"cpf" => cpf} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_path(conn, :show, cpf))

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
      assert response_account["referal_code"] !== nil
    end

    test "renders account when data is valid and fields are incompleted ", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @incomplete_attrs)

      assert %{"cpf" => cpf} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_path(conn, :show, cpf))

      response_account = json_response(conn, 200)["data"]
      assert response_account["birth_date"] == @incomplete_attrs["birth_date"]
      assert response_account["city"] == @incomplete_attrs["city"]
      assert response_account["country"] == @incomplete_attrs["country"]
      assert response_account["cpf"] == @incomplete_attrs["cpf"]
      assert response_account["gender"] == @incomplete_attrs["gender"]
      assert response_account["name"] == @incomplete_attrs["name"]
      assert response_account["state"] == @incomplete_attrs["state"]
      assert response_account["status"] == "pending"
      assert response_account["referal_code"] == nil
    end

    test "renders data when update existing account when incompleted data", %{conn: conn} do
      Accounts.create_account(@incomplete_attrs)

      conn =
        post(conn, Routes.account_path(conn, :create),
          account: %{cpf: @incomplete_attrs["cpf"], name: "Marcos Vinicius"}
        )

      assert %{"cpf" => cpf} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_path(conn, :show, cpf))

      response_account = json_response(conn, 200)["data"]
      assert response_account["birth_date"] == @incomplete_attrs["birth_date"]
      assert response_account["city"] == @incomplete_attrs["city"]
      assert response_account["country"] == @incomplete_attrs["country"]
      assert response_account["cpf"] == @incomplete_attrs["cpf"]
      assert response_account["gender"] == @incomplete_attrs["gender"]
      assert response_account["name"] == "Marcos Vinicius"
      assert response_account["state"] == @incomplete_attrs["state"]
      assert response_account["status"] == "pending"
      assert response_account["referal_code"] == nil
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
    test "renders account when cpf is valid", %{conn: conn} do
      {:ok, _account} = Accounts.create_account(@create_attrs)
      conn = get(conn, Routes.account_path(conn, :show, @create_attrs["cpf"]))
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

    test "renders error when cpf doesn't exist", %{conn: conn} do
      {:ok, _account} = Accounts.create_account(@create_attrs)
      conn = get(conn, Routes.account_path(conn, :show, "111.111.111-11"))
      assert json_response(conn, 200)["data"] == nil
    end
  end
end
