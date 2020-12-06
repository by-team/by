defmodule BYWeb.ErrorViewTest do
  use BYWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(BYWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(BYWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
