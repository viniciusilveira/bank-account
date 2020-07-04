defmodule BankAccountWeb.AccountView do
  use BankAccountWeb, :view
  alias BankAccountWeb.AccountView

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
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
