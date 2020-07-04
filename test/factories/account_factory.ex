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
          country: "Brasil"
        }
      end

      def account_invalid_factory do
        %Account{
          birth_date: nil,
          city: nil,
          country: nil,
          cpf: nil,
          email: nil,
          gender: nil,
          name: nil,
          state: nil
        }
      end
    end
  end
end
