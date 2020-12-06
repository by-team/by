defmodule BY.Repo do
  use Ecto.Repo,
    otp_app: :by,
    adapter: Ecto.Adapters.Postgres
end
