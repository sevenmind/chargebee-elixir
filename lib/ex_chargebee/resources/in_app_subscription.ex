defmodule ExChargebee.InAppSubscription do
  @moduledoc """
  an interface for interacting with Subscriptions
  """
  use ExChargebee.Resource

  def create_for_customer(customer_id, params, opts \\ []) do
    customer_id
    |> ExChargebee.Customer.resource_path()
    |> create_for_parent(params, opts)
  end

  def process_purchase_command(in_app_subscription_app_id, params, opts \\ []) do
    post_resource(in_app_subscription_app_id, "/process_purchase_command", params, opts)
  end

  def import_receipt(in_app_subscription_app_id, params, opts \\ []) do
    post_resource(in_app_subscription_app_id, "/import_receipt", params, opts)
  end

  def import_subscription(in_app_subscription_app_id, params, opts \\ []) do
    post_resource(in_app_subscription_app_id, "/import_subscription", params, opts)
  end

  def retrieve_iap(in_app_subscription_app_id, params, opts \\ []) do
    post_resource(in_app_subscription_app_id, "/retrieve", params, opts)
  end

  # TODO: notifications accepts standard application/json unmodified from the
  # google play or apple store webhooks.
  # def notifications(in_app_subscription_app_id, params) do
  #   post_resource(in_app_subscription_app_id, "/notifications", params)
  # end
end
