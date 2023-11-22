defmodule ExChargebee.NonSubscription do
  @moduledoc """
  an interface for interacting with Non Subscription In App Purchases
  """
  use ExChargebee.Resource,
    stdops: false,
    post_operations: [:one_time_purchase]

  # documentation on this endpoint is unclear
  def non_subscriptions(params, opts \\ []) do
    resource_base_path()
    |> Interface.get(params, opts)
  end
end
