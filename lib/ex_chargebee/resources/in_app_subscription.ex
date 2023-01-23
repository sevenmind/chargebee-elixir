defmodule ExChargebee.InAppSubscription do
  @moduledoc """
  an interface for interacting with Subscriptions
  """
  use ExChargebee.Resource, "in_app_subscription"

  def create_for_customer(customer_id, params) do
    customer_id
    |> ExChargebee.Customer.resource_path()
    |> create_for_parent(params)
  end

  def process_purchase_command(in_app_subscription_app_id, params) do
    post_resource(in_app_subscription_app_id, "/process_purchase_command", params)
  end

  def import_receipt(in_app_subscription_app_id, params) do
    post_resource(in_app_subscription_app_id, "/import_receipt", params)
  end
end
