defmodule BankAccountWeb.UserController do
  use BankAccountWeb, :controller

  alias BankAccount.Guardian
  alias BankAccount.Users
  alias BankAccount.Users.User

  action_fallback BankAccountWeb.FallbackController

  def sign_in(conn, %{"username" => username, "password" => password}) do
    case Users.token_sign_in(username, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end

  def show(conn, _attrs) do
    with %User{} = user <- Guardian.Plug.current_resource(conn) do
      render(conn, "show.json", user: user)
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("jwt.json", %{jwt: token, user: user})
    end
  end

  def update(conn, %{"id" => id, "user" => user_attrs}) do
    with %User{} = logged_user <- Guardian.Plug.current_resource(conn),
         {:ok, :authorized} <- check_logged_user(id, logged_user),
         {:ok, %User{} = user} <- Users.update_user(logged_user, user_attrs) do
      render(conn, "show.json", user: user)
    end
  end

  defp check_logged_user(id, %{id: logged_user_id}) do
    {id, _} = Integer.parse(id)

    case id == logged_user_id do
      true -> {:ok, :authorized}
      _ -> {:error, :unauthorized}
    end
  end
end
