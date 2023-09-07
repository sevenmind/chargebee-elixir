defmodule ExChargebee.Subscription do
  @moduledoc """
  an interface for interacting with Subscriptions
  """
  use ExChargebee.Resource,
    post_operations: [
      :add_charge_at_term_end,
      :cancel_for_items,
      :change_term_end,
      :charge_future_renewals,
      :delete,
      :edit_advance_invoice_schedule,
      :import_contract_term,
      :import_for_items,
      :override_billing_profile,
      :pause,
      :reactivate,
      :regenerate_invoice,
      :remove_advance_invoice_schedule,
      :remove_coupons,
      :remove_scheduled_cancellation,
      :remove_scheduled_changes,
      :remove_scheduled_pause,
      :remove_scheduled_resumption,
      :resume,
      :retrieve_advance_invoice_schedule,
      :subscription_for_items,
      :update_for_items
    ],
    get_operations: [:contract_terms, :discounts, :retrieve_with_scheduled_changes]

  def create_for_customer(customer_id, params, opts \\ []) do
    customer_id
    |> ExChargebee.Customer.resource_path()
    |> create_for_parent(params, "", opts)
  end

  def import_unbilled_charges(params, opts \\ []) do
    post_resource("import_unbilled_charges", "/import_unbilled_charges", params, opts)
  end
end
