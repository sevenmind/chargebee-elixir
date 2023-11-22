defmodule ExChargebee.CouponCode do
  @moduledoc """
  an interface for interacting with Coupon Codes

  Supports:
   - List
   - Retrieve
  """
  use ExChargebee.Resource,
    stdops: [:retrieve, :list],
    post_operations: [:archive]
end
