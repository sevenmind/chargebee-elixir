defmodule ExChargebee.InAppSubscription do
  @moduledoc """
  an interface for interacting with Subscriptions
  """
  use ExChargebee.Resource

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

  # TODO: notifications accepts standard application/json unmodified from the
  # google play or apple store webhooks.
  # def notifications(in_app_subscription_app_id, params) do
  #   post_resource(in_app_subscription_app_id, "/notifications", params)
  # end
end
