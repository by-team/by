defmodule BYWeb.TodoControllerTest do
  use BYWeb.ConnCase

  alias BY.Todos
  alias BY.Todos.Todo

  @create_attrs %{
    done_at: ~N[2010-04-17 14:00:00],
    invoice_link: "some invoice_link",
    invoice_paid_at: ~N[2010-04-17 14:00:00],
    not_done_at: ~N[2010-04-17 14:00:00],
    title: "some title",
    withdraw_link: "some withdraw_link",
    withdrawn_at: ~N[2010-04-17 14:00:00]
  }
  @update_attrs %{
    done_at: ~N[2011-05-18 15:01:01],
    invoice_link: "some updated invoice_link",
    invoice_paid_at: ~N[2011-05-18 15:01:01],
    not_done_at: ~N[2011-05-18 15:01:01],
    title: "some updated title",
    withdraw_link: "some updated withdraw_link",
    withdrawn_at: ~N[2011-05-18 15:01:01]
  }
  @invalid_attrs %{
    done_at: nil,
    invoice_link: nil,
    invoice_paid_at: nil,
    not_done_at: nil,
    title: nil,
    withdraw_link: nil,
    withdrawn_at: nil
  }

  def fixture(:todo) do
    {:ok, todo} = Todos.create_todo(@create_attrs)
    todo
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all todos", %{conn: conn} do
      conn = get(conn, Routes.todo_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "done_at" => "2010-04-17T14:00:00",
               "invoice_link" => "some invoice_link",
               "invoice_paid_at" => "2010-04-17T14:00:00",
               "not_done_at" => "2010-04-17T14:00:00",
               "title" => "some title",
               "withdraw_link" => "some withdraw_link",
               "withdrawn_at" => "2010-04-17T14:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "done_at" => "2011-05-18T15:01:01",
               "invoice_link" => "some updated invoice_link",
               "invoice_paid_at" => "2011-05-18T15:01:01",
               "not_done_at" => "2011-05-18T15:01:01",
               "title" => "some updated title",
               "withdraw_link" => "some updated withdraw_link",
               "withdrawn_at" => "2011-05-18T15:01:01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_todo(_) do
    todo = fixture(:todo)
    %{todo: todo}
  end
end
