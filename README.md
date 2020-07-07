# BankingAccount

Aplication to management Bank Account.

> Elixir, Erlang, Postgres.

---


## Instalation guide

Clone project:
  1. `git clone git@github.com:viniciusilveira/banking_account.git`
  2. `cd banking_api`

## Requisites

- `Elixir 1.10`
- `Erlang 23.0`
- `PostgreSQL 9.6+`

#### 1. Install Postgres

Servidor de banco de dados utilizado.

> OsX:

  ```bash
  brew install postgres
  ```

> Ubuntu:

  ```bash
  sudo apt update
  sudo apt install postgresql postgresql-contrib
  ```

#### 2. Install Erlang and Elixir

Follow instructions from the [installation guide](https://github.com/asdf-vm/asdf#setup) to install asdf.

And using `asdf` to install `Elixir` and `Erlang`:

  ```bash
  asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
  asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

  asdf install erlang 23.0
  asdf install elixir 1.10
  ```

Set global versions:

  ```bash
  asdf global erlang 23.0
  asdf global elixir 1.10
  ```

#### 3. Database Settings

Duplicate files `dev.secret.exs.example` and `test.secret.exs.example`:

  ```bash
  cd banking_account
  cp config/db/dev.secret.exs.example config/db/dev.secret.exs
  cp config/db/test.secret.exs.example config/db/test.secret.exs
  ```
configure database user and password settings;

create database:

  ```bash
  mix ecto.create
  mix ecto.migrate
  ```
Install dependencies:

  ```bash
  mix deps.get
  ```

#### 4. Execute Application

Run server with:

  ```bash
  mix phx.server
  ```

Now you phoenix application is running in `http://localhost:4000`;

#### 5. Tests

run:

  ```bash
  mix test
  ```

## Install with docker


### 1. Duplicate files `dev.secret.exs.example` and `test.secret.exs.example`:

  ```bash
  cd banking_api
  cp config/db/dev.secret.exs.example config/db/dev.secret.exs
  cp config/db/test.secret.exs.example config/db/test.secret.exs
  ```

Changes hostname to `"db"`

### 2. Build and up application:

```bash
docker-compose build
docker-compose up
```

Now you phoenix application is running in http://localhost:4000;

### 3. Run tests

```bash
docker-compose run web mix test
```
## Usage

Please read the [API documentation](api_documentation.md).

## Contribute

Contributions are always welcome!
Please read the [contribution guidelines](contributing.md) first.
