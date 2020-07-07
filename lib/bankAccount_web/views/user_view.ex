defmodule BankAccountWeb.UserView do
  use BankAccountWeb, :view
  alias BankAccountWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end

  def render("jwt.json", %{jwt: jwt, user: user}) do
    %{data: %{id: user.id, username: user.username, jwt: jwt}}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{data: %{jwt: jwt}}
  end
end
