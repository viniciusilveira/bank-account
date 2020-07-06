# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bankAccount,
  ecto_repos: [BankAccount.Repo]

# Configures the endpoint
config :bankAccount, BankAccountWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ndHV7Ais3gGkEkUSjLOeg11LX051+nCgPGhfKzr8WfpCn/8eB/SPineqjKb1IE6h",
  render_errors: [view: BankAccountWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankAccount.PubSub,
  live_view: [signing_salt: "EPcGmhoJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bankAccount, BankAccount.Vault,
  ciphers: [
    default:
      {Cloak.Ciphers.AES.GCM,
       tag: "AES.GCM.V1", key: Base.decode64!("2UkIXDqImnQoks3lh6RDXf94qK33ft59pf6Vo7EQ/QM=")}
  ]

# Guardian config
config :bankAccount, BankAccount.Guardian,
  issuer: "bankAccount",
  secret_key: "IEZjbjEI8+i9U1ZW4KS5BTps2pPUNhQ5dxe1OJ7QYVJqPO6xeRcWXMtumG1569bc"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
