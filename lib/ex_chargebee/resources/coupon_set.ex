defmodule ExChargebee.CouponSet do
  @moduledoc """
  an interface for interacting with Coupon Sets

  Supports
   - List
   - Retrieve
   - Create
   - Update
  """
  use ExChargebee.Resource

  def add_coupon_codes(coupon_id, params, opts \\ []) do
    post_resource(coupon_id, "/add_coupon_codes", params, opts)
  end

  def delete(coupon_id, opts \\ []) do
    post_resource(coupon_id, "/delete", %{}, opts)
  end

  def delete_unused_coupon_codes(coupon_id, opts \\ []) do
    post_resource(coupon_id, "/delete_unused_coupon_codes", %{}, opts)
  end
end
