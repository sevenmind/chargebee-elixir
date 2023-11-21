defmodule ExChargebee.Estimate do
  @moduledoc """
  an interface for interacting with Estimates
  """
  use ExChargebee.Resource,
    post_root_operations: [
      :update_subscription_for_items,
      :gift_subscription_for_items,
      :create_invoice_for_items
    ]
end
