defmodule BY.Repo.Migrations.CreateLNPayInvoices do
  use Ecto.Migration

  def change do
    create table(:lnpay_invoices, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :created_at_in_lnpay, :naive_datetime
      add :ln_node_id, :string
      add :dest_pubkey, :string
      add :payment_request, :text
      add :r_hash_decoded, :string
      add :memo, :string
      add :descripton_bash, :string
      add :num_satoshis, :integer
      add :fee_msat, :integer
      add :expiry, :integer
      add :expires_at, :integer
      add :payment_preimage, :string
      add :settled_at, :naive_datetime
      add :is_keysend, :boolean, default: false, null: false
      add :custom_records, :map
      add :ticket_id, :string
      add :wallet_id, :string

      timestamps()
    end
  end
end
