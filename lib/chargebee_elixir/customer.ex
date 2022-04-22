defmodule ChargebeeElixir.Customer do
  @moduledoc """
  an interface for interacting with Customers
  """
  use ChargebeeElixir.Resource, "customer"


  @doc """
  Merge `from_customer_id` into `to_customer_id`

  This API moves a customer's payment methods, subscriptions, invoices, credit
  notes, transactions, unbilled charges, and orders to another customer. Events
  and email logs will not be moved. The API execution is asynchronous.
  """
  def merge(to_customer_id, from_customer_id) do
    create(%{to_customer_id: to_customer_id, from_customer_id: from_customer_id}, "/merge")
  end
end
