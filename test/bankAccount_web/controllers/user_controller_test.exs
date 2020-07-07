defmodule BankAccountWeb.UserControllerTest do
  use BankAccountWeb.ConnCase

  alias BankAccount.Guardian
  alias BankAccount.Users
  alias BankAccount.Users.User

  import BankAccount.Factory

  @create_attrs string_params_for(:user)
  @update_attrs %{"password" => "ASDFGHJK", "password_confirmation" => "ASDFGHJK"}
  @invalid_attrs string_params_for(:user, password: "123456")

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{"jwt" => jwt, "id" => id, "username" => username} =
               json_response(conn, 201)["data"]

      assert username = @create_attrs["username"]
      assert true = is_binary(jwt)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] == %{
               "password" => ["should be at least 8 character(s)"],
               "password_confirmation" => ["does not match confirmation"]
             }
    end
  end

  describe "sign in" do
    test "renders user when data is valid", %{conn: conn} do
      user = fixture(:user)

      conn =
        post(conn, Routes.user_path(conn, :sign_in), %{
          username: user.username,
          password: user.password
        })

      assert %{"jwt" => jwt} = json_response(conn, 200)["data"]

      assert true = is_binary(jwt)
    end

    test "renders errors when password is invalid", %{conn: conn} do
      user = fixture(:user)

      conn =
        post(conn, Routes.user_path(conn, :sign_in), %{username: user.username, password: "123"})

      assert %{"error" => "Login error"} = json_response(conn, 401)
    end
  end

  describe "update user" do
    setup %{conn: conn} do
      {:ok, user} = Users.create_user(params_for(:user))
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
    end

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert updated_user = json_response(conn, 200)["data"]
      assert updated_user["id"] == id
      assert updated_user["username"] == user.username
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
