defmodule BankAccountWeb.AccountView do
  use BankAccountWeb, :view
  alias BankAccountWeb.AccountView

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("show_with_relateds.json", %{account: account}) do
    %{data: render_one(account, AccountView, "related_accounts.json")}
  end

  def render("related_accounts.json", %{account: account}) do
    Map.put(account_json(account), :accounts_related, render_related_accounts(account))
  end

  def render("account.json", %{account: account}) do
    account_json(account)
  end

  def render("related_account.json", %{account: %{id: id, name: name}}) do
    %{id: id, name: name}
  end

  def render_related_accounts(account) do
    case account.status do
      "completed" ->
        render_many(account.accounts, AccountView, "related_account.json")

      "pending" ->
        %{message: message(account)}
    end
  end

  defp message(%{status: "pending"}),
    do: "Funcionalidade disponível apenas para usuários que completaram o cadastro"

  defp account_json(account) do
    %{
      id: account.id,
      name: account.name,
      email: account.email,
      cpf: account.cpf,
      birth_date: account.birth_date,
      gender: account.gender,
      city: account.city,
      state: account.state,
      country: account.country,
      referral_code: account.referral_code,
      status: account.status
    }
  end
end
