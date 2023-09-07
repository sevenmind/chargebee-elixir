defmodule ExChargebee.NonSubscription do
  @moduledoc """
  an interface for interacting with Non Subscription In App Purchases
  """
  use ExChargebee.Resource

  def one_time_purchase(non_subscription_app_id, params, opts \\ []) do
    post_resource(non_subscription_app_id, "/one_time_purchase", params, opts)
  end
end
