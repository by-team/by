defmodule BYWeb.TodoView do
  use BYWeb, :view
  alias BYWeb.TodoView

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      title: todo.title,
      invoice_link: todo.invoice_link,
      invoice_paid_at: todo.invoice_paid_at,
      done_at: todo.done_at,
      not_done_at: todo.not_done_at,
      withdraw_link: todo.withdraw_link,
      withdrawn_at: todo.withdrawn_at}
  end
end
