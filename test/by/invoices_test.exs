defmodule BY.InvoicesTest do
  use BY.DataCase

  alias BY.Invoices

  describe "lnpay_invoices" do
    alias BY.Invoices.LNPayInvoice

    @valid_attrs %{
      created_at_in_lnpay: ~N[2010-04-17 14:00:00],
      custom_records: %{},
      descripton_bash: "some descripton_bash",
      dest_pubkey: "some dest_pubkey",
      expires_at: 42,
      expiry: 42,
      fee_msat: 42,
      is_keysend: true,
      ln_node_id: "some ln_node_id",
      memo: "some memo",
      num_satoshis: 42,
      payment_preimage: "some payment_preimage",
      payment_request: "some payment_request",
      r_hash_decoded: "some r_hash_decoded",
      settled_at: ~N[2010-04-17 14:00:00],
      ticket_id: "some ticket_id",
      wallet_id: "some wallet_id"
    }
    @update_attrs %{
      created_at_in_lnpay: ~N[2011-05-18 15:01:01],
      custom_records: %{},
      descripton_bash: "some updated descripton_bash",
      dest_pubkey: "some updated dest_pubkey",
      expires_at: 43,
      expiry: 43,
      fee_msat: 43,
      is_keysend: false,
      ln_node_id: "some updated ln_node_id",
      memo: "some updated memo",
      num_satoshis: 43,
      payment_preimage: "some updated payment_preimage",
      payment_request: "some updated payment_request",
      r_hash_decoded: "some updated r_hash_decoded",
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
      settled_at: nil,
      ticket_id: nil,
      wallet_id: nil
    }

    def ln_pay_invoice_fixture(attrs \\ %{}) do
      {:ok, ln_pay_invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Invoices.create_ln_pay_invoice()

      ln_pay_invoice
    end

    test "create_ln_pay_invoice/1 with valid data creates a ln_pay_invoice" do
      assert {:ok, %LNPayInvoice{} = ln_pay_invoice} =
               Invoices.create_ln_pay_invoice(@valid_attrs)

      assert ln_pay_invoice.created_at_in_lnpay == ~N[2010-04-17 14:00:00]
      assert ln_pay_invoice.custom_records == %{}
      assert ln_pay_invoice.descripton_bash == "some descripton_bash"
      assert ln_pay_invoice.dest_pubkey == "some dest_pubkey"
      assert ln_pay_invoice.expires_at == 42
      assert ln_pay_invoice.expiry == 42
      assert ln_pay_invoice.fee_msat == 42
      assert ln_pay_invoice.is_keysend == true
      assert ln_pay_invoice.ln_node_id == "some ln_node_id"
      assert ln_pay_invoice.memo == "some memo"
      assert ln_pay_invoice.num_satoshis == 42
      assert ln_pay_invoice.payment_preimage == "some payment_preimage"
      assert ln_pay_invoice.payment_request == "some payment_request"
      assert ln_pay_invoice.r_hash_decoded == "some r_hash_decoded"
      assert ln_pay_invoice.settled_at == ~N[2010-04-17 14:00:00]
      assert ln_pay_invoice.ticket_id == "some ticket_id"
      assert ln_pay_invoice.wallet_id == "some wallet_id"
    end

    test "create_ln_pay_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoices.create_ln_pay_invoice(@invalid_attrs)
    end

    test "update_ln_pay_invoice/2 with valid data updates the ln_pay_invoice" do
      ln_pay_invoice = ln_pay_invoice_fixture()

      assert {:ok, %LNPayInvoice{} = ln_pay_invoice} =
               Invoices.update_ln_pay_invoice(ln_pay_invoice, @update_attrs)

      assert ln_pay_invoice.created_at_in_lnpay == ~N[2011-05-18 15:01:01]
      assert ln_pay_invoice.custom_records == %{}
      assert ln_pay_invoice.descripton_bash == "some updated descripton_bash"
      assert ln_pay_invoice.dest_pubkey == "some updated dest_pubkey"
      assert ln_pay_invoice.expires_at == 43
      assert ln_pay_invoice.expiry == 43
      assert ln_pay_invoice.fee_msat == 43
      assert ln_pay_invoice.is_keysend == false
      assert ln_pay_invoice.ln_node_id == "some updated ln_node_id"
      assert ln_pay_invoice.memo == "some updated memo"
      assert ln_pay_invoice.num_satoshis == 43
      assert ln_pay_invoice.payment_preimage == "some updated payment_preimage"
      assert ln_pay_invoice.payment_request == "some updated payment_request"
      assert ln_pay_invoice.r_hash_decoded == "some updated r_hash_decoded"
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
