defmodule BY.InvoicesTest do
  use BY.DataCase

  import Tesla.Mock

  alias BY.Invoices

  describe "lnpay_invoices" do
    alias BY.Invoices.LNPayInvoice

    @update_attrs %{
      created_at_in_lnpay: ~N[2011-05-18 15:01:01],
      custom_records: %{},
      descripton_bash: "some updated descripton_bash",
      dest_pubkey: "some updated dest_pubkey",
      expires_at: ~N[2012-05-18 15:01:01],
      expiry: 43,
      fee_msat: 43,
      is_keysend: false,
      ln_node_id: "some updated ln_node_id",
      memo: "some updated memo",
      num_satoshis: 43,
      payment_preimage: "some updated payment_preimage",
      payment_request: "some updated payment_request",
      r_hash_decoded: "some updated r_hash_decoded",
      settled: 0,
      settled_at: ~N[2011-05-18 15:01:01],
      ticket_id: "some updated ticket_id",
      wallet_id: "some updated wallet_id"
    }
    @invalid_attrs %{
      created_at_in_lnpay: nil,
      custom_records: nil,
      descripton_bash: nil,
      dest_pubkey: nil,
      expires_at: nil,
      expiry: nil,
      fee_msat: nil,
      is_keysend: nil,
      ln_node_id: nil,
      memo: nil,
      num_satoshis: nil,
      payment_preimage: nil,
      payment_request: nil,
      r_hash_decoded: nil,
      settled: nil,
      settled_at: nil,
      ticket_id: nil,
      wallet_id: nil
    }
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
      "is_keysend" => nil,
      "ln_node_id" => "lnod_2s4yfYA",
      "memo" => "some memo",
      "num_satoshis" => 1,
      "passThru" => %{"wallet_id" => "wal_czDztN5eJ4r5sJ"},
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

    def ln_pay_invoice_fixture(num_satoshis \\ 42, memo \\ nil) do
      {:ok, ln_pay_invoice} = Invoices.create_ln_pay_invoice(num_satoshis, memo)

      ln_pay_invoice
    end

    test "create_ln_pay_invoice/2 with valid data creates a ln_pay_invoice" do
      assert {:ok, %LNPayInvoice{} = ln_pay_invoice} = Invoices.create_ln_pay_invoice(10)

      assert ln_pay_invoice.created_at_in_lnpay == ~N[2020-12-28 02:52:25]
      assert ln_pay_invoice.custom_records == nil
      assert ln_pay_invoice.descripton_bash == nil

      assert ln_pay_invoice.dest_pubkey ==
               "033868c219bdb51a33560d854d500fe7d3898a1ad9e05dd89d0007e11313588500"

      assert ln_pay_invoice.expires_at == ~N[2020-12-29 02:52:25]
      assert ln_pay_invoice.expiry == 86_400
      assert ln_pay_invoice.fee_msat == 0
      assert ln_pay_invoice.is_keysend == nil
      assert ln_pay_invoice.ln_node_id == "lnod_2s4yfYA"
      assert ln_pay_invoice.memo == "some memo"
      assert ln_pay_invoice.num_satoshis == 1
      assert ln_pay_invoice.payment_preimage == nil

      assert ln_pay_invoice.payment_request ==
               "lnbc10n1p07jjrfpp5ng4d4g3v7wqvclug0rh3jpc2vfnkqqkhhxrufry2fyez96sm0eesdqqcqzpgxqyz5vqsp5s9nt85hwwp2cn2eqff2dxcm97htnw6cdu7rs6qu5340hlqdtxk5s9qy9qsq6a8zhmux47yudqcsr24eym62yfmy29nmeqjpx0w47wcn33pysts9h7ddv4cy2pmmwunapj5zjfgceskc7tncxgx4q63h445lvf3wfkcq3s6sgd"

      assert ln_pay_invoice.r_hash_decoded ==
               "9a2adaa22cf380cc7f8878ef19070a62676002d7b987c48c8a493222ea1b7e73"

      assert ln_pay_invoice.settled == 0
      assert ln_pay_invoice.settled_at == nil
      assert ln_pay_invoice.ticket_id == nil
      assert ln_pay_invoice.wallet_id == "wal_czDztN5eJ4r5sJ"
    end

    test "create_ln_pay_invoice/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoices.create_ln_pay_invoice("num_satoshis", 42)
    end

    test "update_ln_pay_invoice/2 with valid data updates the ln_pay_invoice" do
      ln_pay_invoice = ln_pay_invoice_fixture()

      assert {:ok, %LNPayInvoice{} = ln_pay_invoice} =
               Invoices.update_ln_pay_invoice(ln_pay_invoice, @update_attrs)

      assert ln_pay_invoice.created_at_in_lnpay == ~N[2011-05-18 15:01:01]
      assert ln_pay_invoice.custom_records == %{}
      assert ln_pay_invoice.descripton_bash == "some updated descripton_bash"
      assert ln_pay_invoice.dest_pubkey == "some updated dest_pubkey"
      assert ln_pay_invoice.expires_at == ~N[2012-05-18 15:01:01]
      assert ln_pay_invoice.expiry == 43
      assert ln_pay_invoice.fee_msat == 43
      assert ln_pay_invoice.is_keysend == false
      assert ln_pay_invoice.ln_node_id == "some updated ln_node_id"
      assert ln_pay_invoice.memo == "some updated memo"
      assert ln_pay_invoice.num_satoshis == 43
      assert ln_pay_invoice.payment_preimage == "some updated payment_preimage"
      assert ln_pay_invoice.payment_request == "some updated payment_request"
      assert ln_pay_invoice.r_hash_decoded == "some updated r_hash_decoded"
      assert ln_pay_invoice.settled == 0
      assert ln_pay_invoice.settled_at == ~N[2011-05-18 15:01:01]
      assert ln_pay_invoice.ticket_id == "some updated ticket_id"
      assert ln_pay_invoice.wallet_id == "some updated wallet_id"
    end

    test "update_ln_pay_invoice/2 with invalid data returns error changeset" do
      ln_pay_invoice = ln_pay_invoice_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Invoices.update_ln_pay_invoice(ln_pay_invoice, @invalid_attrs)

      assert ln_pay_invoice == BY.Repo.get!(LNPayInvoice, ln_pay_invoice.id)
    end

    test "change_ln_pay_invoice/1 returns a ln_pay_invoice changeset" do
      ln_pay_invoice = ln_pay_invoice_fixture()
      assert %Ecto.Changeset{} = Invoices.change_ln_pay_invoice(ln_pay_invoice)
    end
  end
end
