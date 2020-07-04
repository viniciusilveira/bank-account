defmodule BankAccountWeb.AccountController do
  use BankAccountWeb, :controller

  alias Brcpfcnpj
  alias BankAccount.Accounts
  alias BankAccount.Accounts.Account

  action_fallback BankAccountWeb.FallbackController

  def create(conn, %{"account" => account_params}) do
    cpf =
      %Cpf{number: account_params["cpf"]}
      |> Brcpfcnpj.cpf_format()

    account_params = Map.merge(account_params, %{"cpf" => cpf})

    with nil <- Accounts.get_account_by_cpf(account_params["cpf"]) do
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
    cpf =
      %Cpf{number: cpf}
      |> Brcpfcnpj.cpf_format()

    account = Accounts.get_account_by_cpf(cpf)
    render(conn, "show.json", account: account)
  end

  defp update(conn, %Account{} = account, account_params) do
    with {:ok, %Account{} = account} <-
           Accounts.update_account(account, Map.delete(account_params, :cpf)) do
      render(conn, "show.json", account: account)
    end
  end
end
