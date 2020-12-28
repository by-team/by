defmodule BY.LNPayTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias BY.LNPay

  @wallet_invoice_id "waki_Q2XHBIfEAN33mLlwdYvusN6Q"
  @wallet_admin_id "wa_Opnn4kGOGBMnfCLFXtsDnjTb"

  @invoice %{
    "created_at" => 1_609_123_945,
    "custom_records" => nil,
    "description_hash" => nil,
    "dest_pubkey" => "033868c219bdb51a33560d854d500fe7d3898a1ad9e05dd89d0007e11313588500",
    "expires_at" => 1_609_210_345,
    "expiry" => 86_400,
    "fee_msat" => 0,
    "id" => "lntx_XutcfxmqGuN4tp1UJnuscBp",
    "ln_node_id" => "lnod_2s4yfYA",
    "is_keysend" => nil,
    "memo" => "",
    "num_satoshis" => 1,
    "passThru" => %{"wallet_id" => "wal_czDztN5eJ4r5sJ", "ticketId" => "556"},
    "payment_preimage" => nil,
    "payment_request" =>
      "lnbc10n1p07jjrfpp5ng4d4g3v7wqvclug0rh3jpc2vfnkqqkhhxrufry2fyez96sm0eesdqqcqzpgxqyz5vqsp5s9nt85hwwp2cn2eqff2dxcm97htnw6cdu7rs6qu5340hlqdtxk5s9qy9qsq6a8zhmux47yudqcsr24eym62yfmy29nmeqjpx0w47wcn33pysts9h7ddv4cy2pmmwunapj5zjfgceskc7tncxgx4q63h445lvf3wfkcq3s6sgd",
    "r_hash_decoded" => "9a2adaa22cf380cc7f8878ef19070a62676002d7b987c48c8a493222ea1b7e73",
    "settled" => 0,
    "settled_at" => nil
  }

  @withdraw %{
    "lnurl" =>
      "LNURL1DP68GURN8GHJ7MRWWPSHJTNRDUHHVVF0WASKCMR9WSHHWC2LFACXUM35DDR5736ZF4HXVS6VGEV8GU6YDE49GC30D3H82UNV94C8YMMRV4EHX0M0W36R63JRT98JVMN4D40HXCT5DAEKS6TN85CJVMT9D4HN6Y6HP5R",
    "num_satoshis" => 4,
    "ott" => "FCYO"
  }

  setup do
    mock(fn
      %{
        method: :post,
        url: "https://lnpay.co/v1/wallet/#{@wallet_invoice_id}/invoice",
        body: "{\"memo\":null,\"num_satoshis\":1}"
      } ->
        %Tesla.Env{status: 408}

      %{method: :post, url: "https://lnpay.co/v1/wallet/#{@wallet_invoice_id}/invoice"} ->
        %Tesla.Env{status: 201, body: @invoice}

      %{
        method: :get,
        url: "https://lnpay.co/v1/wallet/#{@wallet_admin_id}/lnurl/withdraw",
        query: [num_satoshis: 1, memo: nil]
      } ->
        %Tesla.Env{status: 500}

      %{method: :get, url: "https://lnpay.co/v1/wallet/#{@wallet_admin_id}/lnurl/withdraw"} ->
        %Tesla.Env{status: 200, body: @withdraw}
    end)

    :ok
  end

  describe "generate_invoice/2" do
    test "timeout" do
      assert LNPay.generate_invoice(1, nil) == {:error, :timeout}
    end

    test "returns a invoice" do
      assert LNPay.generate_invoice(2, "") == {
               :ok,
               %{
                 created_at_in_lnpay: ~N[2020-12-28 02:52:25],
                 custom_records: nil,
                 descripton_hash: nil,
                 dest_pubkey:
                   "033868c219bdb51a33560d854d500fe7d3898a1ad9e05dd89d0007e11313588500",
                 expires_at: ~N[2020-12-29 02:52:25],
                 expiry: 86_400,
                 fee_msat: 0,
                 is_keysend: nil,
                 id: "lntx_XutcfxmqGuN4tp1UJnuscBp",
                 ln_node_id: "lnod_2s4yfYA",
                 memo: "",
                 num_satoshis: 1,
                 payment_preimage: nil,
                 payment_request:
                   "lnbc10n1p07jjrfpp5ng4d4g3v7wqvclug0rh3jpc2vfnkqqkhhxrufry2fyez96sm0eesdqqcqzpgxqyz5vqsp5s9nt85hwwp2cn2eqff2dxcm97htnw6cdu7rs6qu5340hlqdtxk5s9qy9qsq6a8zhmux47yudqcsr24eym62yfmy29nmeqjpx0w47wcn33pysts9h7ddv4cy2pmmwunapj5zjfgceskc7tncxgx4q63h445lvf3wfkcq3s6sgd",
                 r_hash_decoded:
                   "9a2adaa22cf380cc7f8878ef19070a62676002d7b987c48c8a493222ea1b7e73",
                 settled: 0,
                 settled_at: nil,
                 ticket_id: "556",
                 wallet_id: "wal_czDztN5eJ4r5sJ"
               }
             }
    end
  end

  describe "generate_withdraw/2" do
    test "lpnay error" do
      assert LNPay.generate_withdraw(1, nil) == {:error, :lnpay_error}
    end

    test "returns a withdraw" do
      assert LNPay.generate_withdraw(2, "") == {:ok, @withdraw}
    end
  end
end
