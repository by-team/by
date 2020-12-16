defmodule BY.Lnpay.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://lnpay.co/v1/"
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.BasicAuth, username: @token

  @token ""
  @wallet_invoice_id ""
  @wallet_admin_id ""

  def generate_invoice(num_satoshis, memo) do
    body = %{num_satoshis: num_satoshis, memo: memo}

    "wallet/#{@wallet_invoice_id}/invoice"
    |> post(body)
    |> handle_generate_invoice()
  end

  defp handle_generate_invoice({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}
  defp handle_generate_invoice({:ok, %Tesla.Env{status: 201, body: body}}), do: {:ok, body}
  defp handle_generate_invoice({:ok, %Tesla.Env{status: 401, body: body}}), do: {:error, body}
  defp handle_generate_invoice({:ok, %Tesla.Env{status: 404, body: body}}), do: {:error, body}

  def get_invoice() do
    "lntx/lntx_dPs4PNKiaXUHoHqZsroVcK9g"
    |> get()
    |> handle_get_invoice()
  end

  defp handle_get_invoice({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}
  defp handle_get_invoice({:ok, %Tesla.Env{status: 401, body: body}}), do: {:error, body}
  defp handle_get_invoice({:ok, %Tesla.Env{status: 404, body: body}}), do: {:error, body}

  def get_withdraw_link(num_satoshis, memo) do
    get("wallet/#{@wallet_admin_id}/lnurl/withdraw",
      query: [num_satoshis: num_satoshis, memo: memo]
    )
    |> handle_get_invoice()
  end

  defp handle_get_withdraw_link({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}
  defp handle_get_withdraw_link({:ok, %Tesla.Env{status: 401, body: body}}), do: {:error, body}
  defp handle_get_withdraw_link({:ok, %Tesla.Env{status: 404, body: body}}), do: {:error, body}
end
