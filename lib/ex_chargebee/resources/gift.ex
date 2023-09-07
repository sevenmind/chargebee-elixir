defmodule ExChargebee.Gift do
  @moduledoc """
  An interface for interacting with Chargebee Gifts
  """
  use ExChargebee.Resource

  def create_for_items(params, opts \\ []) do
    create(params, "/create_for_items", opts)
  end

  def cancel(coupon_id, opts \\ []) do
    post_resource(coupon_id, "/cancel", %{}, opts)
  end

  def claim(coupon_id, opts \\ []) do
    post_resource(coupon_id, "/claim", %{}, opts)
  end
end
