defmodule ExChargebee.Usage do
  @moduledoc """
  an interface for interacting with Purchases
  """
  use ExChargebee.Resource,
    stdops: [:list],
    post_root_operations: [:pdf]

  defdelegate create_usage(subscription_id, params, opts \\ []), to: ExChargebee.Subscription
  defdelegate delete_usage(subscription_id, params, opts \\ []), to: ExChargebee.Subscription
end
