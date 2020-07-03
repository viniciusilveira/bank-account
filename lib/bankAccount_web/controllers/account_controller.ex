defmodule BankAccountWeb.AccountController do
  use BankAccountWeb, :controller

  alias BankAccount.Accounts
  alias BankAccount.Accounts.Account

  action_fallback BankAccountWeb.FallbackController

  def create(conn, %{"account" => account_params}) do
    with nil <- Accounts.get_account_by(account_params["cpf"]) do
      with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.account_path(conn, :show, account))
        |> render("show.json", account: account)
      end
    else
      account = %Account{} ->
        conn
        |> update(account, account_params)
    end
  end

  def show(conn, %{"cpf" => cpf}) do
    account = Accounts.get_account_by(cpf)
    render(conn, "show.json", account: account)
  end

  defp update(conn, %Account{} = account, account_params) do
    with {:ok, %Account{} = account} <-
           Accounts.update_account(account, Map.delete(account_params, :cpf)) do
      render(conn, "show.json", account: account)
    end
  end
end
