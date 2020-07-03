defmodule BankAccount.AccountFactory do
  alias BankAccount.Accounts.Account

  alias Faker
  alias Brcpfcnpj

  defmacro __using__(_opts) do
    quote do
      def account_factory do
        %Account{
          name: Faker.StarWars.character(),
          cpf: Brcpfcnpj.cpf_generate(true),
          email: Faker.Internet.email(),
          birth_date: "12/07/1994",
          gender: "Masculino",
          city: "Belo Horizonte",
          state: "Minas Gerais",
          country: "Brasil",
          referal_code: "12345678"
        }
      end
    end
  end
end
