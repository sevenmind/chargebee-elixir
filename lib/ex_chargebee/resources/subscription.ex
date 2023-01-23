defmodule ExChargebee.Subscription do
  @moduledoc """
  an interface for interacting with Subscriptions
  """
  use ExChargebee.Resource

  def create_for_customer(customer_id, params) do
    customer_id
    |> ExChargebee.Customer.resource_path()
    |> create_for_parent(params)
  end
end
