defmodule ExChargebee.Coupon do
  @moduledoc """
  an interface for interacting with Coupons
  """
  use ExChargebee.Resource,
    stdops: [
      :retrieve,
      :list,
      :delete
    ],
    post_root_operations: [:create_for_items],
    post_operations: [:update_for_items, :copy, :unarchive]
end
