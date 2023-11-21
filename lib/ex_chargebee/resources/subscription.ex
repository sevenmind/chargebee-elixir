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
      :update_for_items
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

  @doc """
  Return a list of Subscription usages
  [chargebee docs](https://apidocs.chargebee.com/docs/api/usages?lang=curl#list_usages)
  """
  def list_usages(subscription_id, params, opts \\ []) do
    ExChargebee.Interface.stream_list(
      params,
      resource_path(subscription_id, "/usages"),
      "usage",
      opts
    )
    |> Enum.to_list()
  end

  @doc """
  Create a Subscription usage
  [chargebee docs](https://apidocs.chargebee.com/docs/api/usages?lang=curl#create_a_usage)
  """
  def create_usage(subscription_id, params, opts \\ []) do
    resource_path(subscription_id, "/usages")
    |> ExChargebee.Interface.post(params, opts)
    |> Map.get("usage")
  end

  @doc """
  Create a Subscription usage
  [chargebee docs](https://apidocs.chargebee.com/docs/api/usages?lang=curl#delete_a_usage)
  """
  def delete_usage(subscription_id, params, opts \\ []) do
    resource_path(subscription_id, "/delete_usage")
    |> ExChargebee.Interface.post(params, opts)
    |> Map.get("usage")
  end
end
