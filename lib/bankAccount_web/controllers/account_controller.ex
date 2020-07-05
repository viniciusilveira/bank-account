defmodule BankAccountWeb.AccountController do
  use BankAccountWeb, :controller

  alias Brcpfcnpj
  alias BankAccount.Accounts
  alias BankAccount.Accounts.Account

  action_fallback BankAccountWeb.FallbackController

  def create(conn, %{"account" => account_params}) do
    cpf = format_cpf(account_params)

    account_params = Map.merge(account_params, %{"cpf" => cpf})

    with nil <- Accounts.get_account_by_cpf(account_params["cpf"]) do
      with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.account_path(conn, :show, account))
        |> render("show.json", %{account: account, message: get_message(account)})
      end
    else
      account = %Account{} ->
        conn
        |> update(account, account_params)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Account{} = account} <- Accounts.get_account(id) do
      render(conn, "show_with_relateds.json", account: account)
    end
  end

  defp update(conn, %Account{} = account, account_params) do
    with {:ok, %Account{} = account} <-
           Accounts.update_account(account, Map.delete(account_params, :cpf)) do
      render(conn, "show.json", %{account: account, message: get_message(account)})
    end
  end

  defp get_message(%{status: "completed", referral_code: referral_code}),
    do: "Seus dados estão completos. Utilize o código #{referral_code} para convidar seus amigos."

  defp get_message(%{status: "pending"}),
    do: "Dados salvos! Envie as informações que estão faltando para finalizar o cadastro."

  defp format_cpf(%{"cpf" => cpf}) do
    case formated_cpf = %Cpf{number: cpf} |> Brcpfcnpj.cpf_format() do
      nil -> cpf
      _ -> formated_cpf
    end
  end
end
