defmodule BY.Invoices do
  @moduledoc """
  The Invoices context.
  """

  import Ecto.Query, warn: false
  alias BY.Repo

  alias BY.Invoices.LNPayInvoice

  @doc """
  Returns the list of lnpay_invoices.

  ## Examples

      iex> list_lnpay_invoices()
      [%LNPayInvoice{}, ...]

  """
  def list_lnpay_invoices do
    Repo.all(LNPayInvoice)
  end

  @doc """
  Gets a single ln_pay_invoice.

  Raises `Ecto.NoResultsError` if the Ln pay invoice does not exist.

  ## Examples

      iex> get_ln_pay_invoice!(123)
      %LNPayInvoice{}

      iex> get_ln_pay_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ln_pay_invoice!(id), do: Repo.get!(LNPayInvoice, id)

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
  Deletes a ln_pay_invoice.

  ## Examples

      iex> delete_ln_pay_invoice(ln_pay_invoice)
      {:ok, %LNPayInvoice{}}

      iex> delete_ln_pay_invoice(ln_pay_invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ln_pay_invoice(%LNPayInvoice{} = ln_pay_invoice) do
    Repo.delete(ln_pay_invoice)
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
