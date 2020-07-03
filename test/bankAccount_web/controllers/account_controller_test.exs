defmodule BankAccountWeb.AccountControllerTest do
  use BankAccountWeb.ConnCase

  alias BankAccount.Accounts

  import BankAccount.Factory

  @create_attrs params_for(:account)
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
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @create_attrs)
      assert %{"cpf" => cpf} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_path(conn, :show, cpf))

      attrs = keys_to_string(@create_attrs)

      assert attrs == json_response(conn, 200)["data"]
    end

    test "renders errors when cpf is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_path(conn, :create),
          account: params_for(:account, cpf: "315.694.100-04")
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_path(conn, :create),
          account: params_for(:account, email: "invalidmail.com")
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when birth_date is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_path(conn, :create),
          account: params_for(:account, birth_date: "12/11/2019d")
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
      conn = get(conn, Routes.account_path(conn, :show, @create_attrs.cpf))
      attrs = keys_to_string(@create_attrs)
      assert attrs == json_response(conn, 200)["data"]
    end

    test "renders error when cpf doesn't exist", %{conn: conn} do
      {:ok, _account} = Accounts.create_account(@create_attrs)
      conn = get(conn, Routes.account_path(conn, :show, "111.111.111-11"))
      assert json_response(conn, 200)["data"] == nil
    end
  end

  defp keys_to_string(map) do
    map
    |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)
  end
end
