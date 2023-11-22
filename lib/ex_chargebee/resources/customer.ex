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
    post_operations: [
      :add_contact,
      :assign_payment_role,
      :change_billing_date,
      :clear_personal_data,
      :collect_payment,
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
    post_root_operations: [:move, :merge],
    list_operations: [:payment_vouchers, :contacts]

  @spec hierarchy(String.t(), map, Keyword.t()) :: [map]
  def hierarchy(customer_id, params, opts \\ []) do
    resource_path(customer_id, "/hierarchy")
    |> ExChargebee.Interface.get(params, opts)
    |> Map.get("hierarchies")
  end
end
