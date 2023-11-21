defmodule ExChargebee.CouponSet do
  @moduledoc """
  an interface for interacting with Coupon Sets

  Supports
   - List
   - Retrieve
   - Create
   - Update
  """
  use ExChargebee.Resource,
    # stdops: true,
    post_operations: [
      :add_coupon_codes,
      :delete_unused_coupon_codes
    ]
end
