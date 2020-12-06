defmodule BY.Invoices do
  @moduledoc """
  The Invoices context.
  """

  import Ecto.Query, warn: false
  alias BY.Repo

  alias BY.Invoices.LNPayInvoice

  @doc """
  Creates a ln_pay_invoice.

  ## Examples

      iex> create_ln_pay_invoice(%{field: value})
      {:ok, %LNPayInvoice{}}

      iex> create_ln_pay_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ln_pay_invoice(attrs \\ %{}) do
    %LNPayInvoice{}
    |> LNPayInvoice.changeset(attrs)
    |> Repo.insert()
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
