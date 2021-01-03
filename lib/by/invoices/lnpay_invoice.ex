defmodule BY.Invoices.LNPayInvoice do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lnpay_invoices" do
    field :created_at_in_lnpay, :naive_datetime
    field :custom_records, :map
    field :descripton_bash, :string
    field :dest_pubkey, :string
    field :expires_at, :naive_datetime
    field :expiry, :integer
    field :fee_msat, :integer
    field :is_keysend, :boolean, default: false
    field :ln_node_id, :string
    field :memo, :string
    field :num_satoshis, :integer
    field :payment_preimage, :string
    field :payment_request, :string
    field :r_hash_decoded, :string
    field :settled, :integer
    field :settled_at, :naive_datetime
    field :ticket_id, :string
    field :wallet_id, :string

    timestamps()
  end

  @doc false
  def changeset(lnpay_invoice, attrs) do
    lnpay_invoice
    |> cast(attrs, [
      :created_at_in_lnpay,
      :ln_node_id,
      :dest_pubkey,
      :payment_request,
      :r_hash_decoded,
      :memo,
      :descripton_bash,
      :num_satoshis,
      :fee_msat,
      :expiry,
      :expires_at,
      :payment_preimage,
      :settled_at,
      :settled,
      :is_keysend,
      :custom_records,
      :ticket_id,
      :wallet_id
    ])
    |> validate_required([
      :created_at_in_lnpay,
      :ln_node_id,
      :dest_pubkey,
      :payment_request,
      :r_hash_decoded,
      :num_satoshis,
      :fee_msat,
      :expiry,
      :expires_at,
      :wallet_id
    ])
  end
end
