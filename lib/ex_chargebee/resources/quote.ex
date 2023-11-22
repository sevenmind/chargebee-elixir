defmodule ExChargebee.Quote do
  @moduledoc """
  an interface for interacting with Quotes
  """

  use ExChargebee.Resource,
    stdops: [
      :retrieve,
      :list,
      :delete
    ],
    post_operations: [
      :edit_create_subscription_quote_for_items,
      :edit_update_subscription_quote_for_items,
      :edit_for_charge_items_and_charges,
      :convert,
      :update_status,
      :extend_expiry_date,
      {"download", :pdf}
    ],
    post_root_operations: [
      :update_subscription_quote_for_items,
      :create_for_charge_items_and_charges
    ],
    list_operations: [:quote_line_groups]
end
