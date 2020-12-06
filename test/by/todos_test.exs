defmodule BY.TodosTest do
  use BY.DataCase

  alias BY.Todos

  describe "todos" do
    alias BY.Todos.Todo

    @valid_attrs %{done_at: ~N[2010-04-17 14:00:00], invoice_link: "some invoice_link", invoice_paid_at: ~N[2010-04-17 14:00:00], not_done_at: ~N[2010-04-17 14:00:00], title: "some title", withdraw_link: "some withdraw_link", withdrawn_at: ~N[2010-04-17 14:00:00]}
    @update_attrs %{done_at: ~N[2011-05-18 15:01:01], invoice_link: "some updated invoice_link", invoice_paid_at: ~N[2011-05-18 15:01:01], not_done_at: ~N[2011-05-18 15:01:01], title: "some updated title", withdraw_link: "some updated withdraw_link", withdrawn_at: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{done_at: nil, invoice_link: nil, invoice_paid_at: nil, not_done_at: nil, title: nil, withdraw_link: nil, withdrawn_at: nil}

    def todo_fixture(attrs \\ %{}) do
      {:ok, todo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todos.create_todo()

      todo
    end

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      assert {:ok, %Todo{} = todo} = Todos.create_todo(@valid_attrs)
      assert todo.done_at == ~N[2010-04-17 14:00:00]
      assert todo.invoice_link == "some invoice_link"
      assert todo.invoice_paid_at == ~N[2010-04-17 14:00:00]
      assert todo.not_done_at == ~N[2010-04-17 14:00:00]
      assert todo.title == "some title"
      assert todo.withdraw_link == "some withdraw_link"
      assert todo.withdrawn_at == ~N[2010-04-17 14:00:00]
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, @update_attrs)
      assert todo.done_at == ~N[2011-05-18 15:01:01]
      assert todo.invoice_link == "some updated invoice_link"
      assert todo.invoice_paid_at == ~N[2011-05-18 15:01:01]
      assert todo.not_done_at == ~N[2011-05-18 15:01:01]
      assert todo.title == "some updated title"
      assert todo.withdraw_link == "some updated withdraw_link"
      assert todo.withdrawn_at == ~N[2011-05-18 15:01:01]
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
