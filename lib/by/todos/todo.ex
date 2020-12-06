defmodule BY.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todos" do
    field :done_at, :naive_datetime
    field :invoice_link, :string
    field :invoice_paid_at, :naive_datetime
    field :not_done_at, :naive_datetime
    field :title, :string
    field :withdraw_link, :string
    field :withdrawn_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [
      :title,
      :invoice_link,
      :invoice_paid_at,
      :done_at,
      :not_done_at,
      :withdraw_link,
      :withdrawn_at
    ])
    |> validate_required([:title])
  end
end
