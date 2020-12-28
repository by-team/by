defmodule BY.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :invoice_link, :string
      add :invoice_paid_at, :naive_datetime
      add :done_at, :naive_datetime
      add :not_done_at, :naive_datetime
      add :withdraw_link, :string
      add :withdrawn_at, :naive_datetime

      timestamps()
    end
  end
end
