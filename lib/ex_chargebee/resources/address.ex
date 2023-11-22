defmodule ExChargebee.Address do
  @moduledoc """
  An interface for interacting with Chargebee Addresses
  """
  use ExChargebee.Resource,
    stdops: false

  def retrieve(params, opts \\ []) do
    resource_base_path()
    |> Interface.get(params, opts)
    |> Map.get("address")
  end

  def update(params, opts \\ []) do
    resource_base_path()
    |> Interface.post(params, opts)
    |> Map.get("address")
  end
end
