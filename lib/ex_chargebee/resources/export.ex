defmodule ExChargebee.Export do
  @moduledoc """
  an interface for interacting with Exports
  """
  use ExChargebee.Resource,
    stdops: [
      :retrieve
    ],
    post_root_operations: [
      :attached_items,
      :coupons,
      :credit_notes,
      :customers,
      :deferred_revenue,
      :differential_prices,
      :invoices,
      :item_families,
      :item_prices,
      :items,
      :orders,
      :revenue_recognition,
      :subscriptions,
      :transactions
    ]
end
