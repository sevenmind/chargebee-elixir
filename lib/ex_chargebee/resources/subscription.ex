defmodule ExChargebee.Subscription do
  @moduledoc """
  an interface for interacting with Subscriptions
  """
  use ExChargebee.Resource,
    stdops: [
      :list,
      :retrieve,
      :delete
    ],
    post_operations: [
      :add_charge_at_term_end,
      :cancel_for_items,
      :change_term_end,
      :charge_future_renewals,
      :edit_advance_invoice_schedule,
      :import_contract_term,
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
      :update_for_items,
      {"usage", :create_usage},
      {"usage", :delete_usage}
    ],
    get_operations: [:contract_terms, :discounts, :retrieve_with_scheduled_changes]

  @doc """
  [chargebee docs](https://apidocs.chargebee.com/docs/api/subscriptions?lang=curl#import_unbilled_charges)
  """
  def import_unbilled_charges(params, opts \\ []) do
    "import_unbilled_charges"
    |> resource_path("/import_unbilled_charges")
    |> ExChargebee.Interface.post(params, opts)
    |> Map.get("unbilled_charges")
  end

  defdelegate import_for_items(customer_id, params, opts), to: ExChargebee.Customer
  defdelegate subscription_for_items(customer_id, params, opts), to: ExChargebee.Customer
end
