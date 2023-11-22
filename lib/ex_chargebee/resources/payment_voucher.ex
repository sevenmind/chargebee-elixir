defmodule ExChargebee.PaymentVoucher do
  @moduledoc """
  an interface for interacting with PaymentVoucher
  """
  use ExChargebee.Resource,
    stdops: [
      :create,
      :retrieve
    ]

  def list_vouchers_for_customer(customer_id, params, opts \\ []),
    do: ExChargebee.Customer.list_payment_vouchers(customer_id, params, opts)

  def list_vouchers_for_invoice(customer_id, params, opts \\ []),
    do: ExChargebee.Customer.list_payment_vouchers(customer_id, params, opts)
end
