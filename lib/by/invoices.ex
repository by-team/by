defmodule BY.Invoices do
  @moduledoc """
  The Invoices context.
  """

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias BY.Invoices.LNPayInvoice
  alias BY.Repo

  @doc """
  Creates a ln_pay_invoice.

  ## Examples

      iex> create_ln_pay_invoice(num_satoshis, memo)
      {:ok, %LNPayInvoice{}}

      iex> create_ln_pay_invoice(bad_value, bad_value)
      {:error, %Ecto.Changeset{}}

  """
  def create_ln_pay_invoice(num_satoshis, memo \\ nil) do
    data = %{}
    types = %{num_satoshis: :integer, memo: :string}

    changeset =
      {data, types}
      |> Ecto.Changeset.cast(%{num_satoshis: num_satoshis, memo: memo}, Map.keys(types))
      |> validate_required([:num_satoshis])

    if changeset.valid? do
      case BY.LNPay.generate_invoice(num_satoshis, memo) do
        {:ok, invoice} ->
          %LNPayInvoice{}
          |> LNPayInvoice.changeset(invoice)
          |> Repo.insert()

        error ->
          error
      end
    else
      {:error, changeset}
    end
  end

  @doc """
  Updates a ln_pay_invoice.

  ## Examples

      iex> update_ln_pay_invoice(ln_pay_invoice, %{field: new_value})
      {:ok, %LNPayInvoice{}}

      iex> update_ln_pay_invoice(ln_pay_invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ln_pay_invoice(%LNPayInvoice{} = ln_pay_invoice, attrs) do
    ln_pay_invoice
    |> LNPayInvoice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ln_pay_invoice changes.

  ## Examples

      iex> change_ln_pay_invoice(ln_pay_invoice)
      %Ecto.Changeset{data: %LNPayInvoice{}}

  """
  def change_ln_pay_invoice(%LNPayInvoice{} = ln_pay_invoice, attrs \\ %{}) do
    LNPayInvoice.changeset(ln_pay_invoice, attrs)
  end
end
