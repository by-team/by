defmodule BY.LNPay do
  @moduledoc """
  LNPay API documentation: https://docs.lnpay.co/.
  """

  use Tesla

  require Logger

  @token Application.compile_env!(:by, [__MODULE__, :token])
  @wallet_invoice_id Application.compile_env!(:by, [__MODULE__, :wallet_invoice_id])
  @wallet_admin_id Application.compile_env!(:by, [__MODULE__, :wallet_admin_id])

  plug Tesla.Middleware.BaseUrl, "https://lnpay.co/v1/"
  plug Tesla.Middleware.BasicAuth, username: @token
  plug Tesla.Middleware.JSON

  def generate_invoice(num_satoshis, memo) do
    "wallet/#{@wallet_invoice_id}/invoice"
    |> post(%{num_satoshis: num_satoshis, memo: memo})
    |> handle_generate_invoice()
  end

  def generate_withdraw(num_satoshis, memo) do
    "wallet/#{@wallet_admin_id}/lnurl/withdraw"
    |> get(query: [num_satoshis: num_satoshis, memo: memo])
    |> handle_response(200)
  end

  defp handle_generate_invoice(response) do
    case handle_response(response, 201) do
      {:ok,
       %{
         "created_at" => created_at_in_lnpay,
         "custom_records" => custom_records,
         "description_hash" => description_hash,
         "dest_pubkey" => dest_pubkey,
         "expires_at" => expires_at,
         "expiry" => expiry,
         "fee_msat" => fee_msat,
         "id" => id,
         "ln_node_id" => ln_node_id,
         "is_keysend" => is_keysend,
         "memo" => memo,
         "num_satoshis" => num_satoshis,
         "passThru" => %{"wallet_id" => wallet_id},
         "payment_preimage" => payment_preimage,
         "payment_request" => payment_request,
         "r_hash_decoded" => r_hash_decoded,
         "settled" => settled,
         "settled_at" => settled_at
       } = invoice} ->
        ticket_id = get_in(invoice, ["passThru", "ticketId"])

        {:ok,
         %{
           created_at_in_lnpay: unix_to_naive_datetime(created_at_in_lnpay),
           custom_records: custom_records,
           descripton_hash: description_hash,
           dest_pubkey: dest_pubkey,
           expires_at: unix_to_naive_datetime(expires_at),
           expiry: expiry,
           fee_msat: fee_msat,
           is_keysend: is_keysend,
           ln_node_id: ln_node_id,
           id: id,
           memo: memo,
           num_satoshis: num_satoshis,
           payment_preimage: payment_preimage,
           payment_request: payment_request,
           r_hash_decoded: r_hash_decoded,
           settled: settled,
           settled_at: unix_to_naive_datetime(settled_at),
           ticket_id: ticket_id,
           wallet_id: wallet_id
         }}

      error ->
        error
    end
  end

  defp unix_to_naive_datetime(nil), do: nil

  defp unix_to_naive_datetime(datetime) do
    datetime |> DateTime.from_unix!() |> DateTime.to_naive()
  end

  defp handle_response(
         {:ok, %Tesla.Env{status: expected_status, body: response}},
         expected_status
       ) do
    {:ok, response}
  end

  defp handle_response({:ok, %Tesla.Env{status: status}}, _expected_status)
       when status in [408, 504] do
    {:error, :timeout}
  end

  defp handle_response({:ok, %Tesla.Env{status: status}}, _expected_status)
       when status in [500, 501, 502, 503, 505, 506, 507, 508, 510, 511] do
    {:error, :service_provider_error}
  end
end
