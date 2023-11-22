defmodule ExChargebee.InAppSubscription do
  @moduledoc """
  an interface for interacting with Subscriptions
  """
  use ExChargebee.Resource,
    stdops: false,
    post_operations: [
      :process_purchase_command,
      :import_receipt,
      :import_subscription,
      :retrieve
    ]

  # TODO: notifications accepts standard application/json unmodified from the
  # google play or apple store webhooks.
  # def notifications(in_app_subscription_app_id, params) do
  #   post_resource(in_app_subscription_app_id, "/notifications", params)
  # end
end
