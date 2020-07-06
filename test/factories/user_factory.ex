defmodule BankAccount.UserFactory do
  alias BankAccount.Users.User

  alias Faker.Internet

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          username: Internet.user_name(),
          password: "12345678",
          password_confirmation: "12345678"
        }
      end
    end
  end
end
