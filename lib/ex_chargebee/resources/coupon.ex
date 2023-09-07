defmodule ExChargebee.Coupon do
  @moduledoc """
  an interface for interacting with Coupons
  """
  use ExChargebee.Resource

  def create_for_items(params, opts \\ []) do
    create(params, "/create_for_items", opts)
  end

  def update_for_items(coupon_id, params, opts \\ []) do
    post_resource(coupon_id, "/update_for_items", params, opts)
  end

  def delete(coupon_id, opts \\ []) do
    post_resource(coupon_id, "/delete", %{}, opts)
  end

  def copy(coupon_id, params, opts \\ []) do
    post_resource(coupon_id, "/copy", params, opts)
  end

  def unarchive(coupon_id, opts \\ []) do
    post_resource(coupon_id, "/unarchive", %{}, opts)
  end
end
