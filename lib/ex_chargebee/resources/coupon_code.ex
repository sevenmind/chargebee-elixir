defmodule ExChargebee.CouponCode do
  @moduledoc """
  an interface for interacting with Coupon Codes

  Supports:
   - List
   - Retrieve
  """
  use ExChargebee.Resource, "coupon_code"

  def archive(coupon_code) do
    post_resource(coupon_code, "/archive", %{})
  end
end
