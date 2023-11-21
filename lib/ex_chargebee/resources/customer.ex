defmodule ExChargebee.Customer do
  @moduledoc """
  an interface for interacting with Customers
  """
  use ExChargebee.Resource,
    stdops: [
      :create,
      :retrieve,
      :list,
      :update,
      :delete
    ],
    get_operations: [
      :contacts,
      :hierarchy
    ],
    post_operations: [
      :add_contact,
      :assign_payment_role,
      :change_billing_date,
      :clear_personal_data,
      :collect_payment,
      :delete,
      :delete_contact,
      :delete_relationship,
      :record_excess_payment,
      :relationships,
      :update_billing_info,
      :update_contact,
      :update_hierarchy_settings,
      :update_payment_method,
      :subscription_for_items
    ],
    post_root_operations: [:move],
    list_operations: [:payment_vouchers]

  @doc """
  Merge `from_customer_id` into `to_customer_id`

  This API moves a customer's payment methods, subscriptions, invoices, credit
  notes, transactions, unbilled charges, and orders to another customer. Events
  and email logs will not be moved. The API execution is asynchronous.
  """
  def merge(to_customer_id, from_customer_id, opts \\ []) do
    merge(%{to_customer_id: to_customer_id, from_customer_id: from_customer_id}, opts)
  end
end
