defmodule Pulpit.Repo do
  use Ecto.Repo,
    otp_app: :pulpit,
    adapter: Ecto.Adapters.Postgres
end
