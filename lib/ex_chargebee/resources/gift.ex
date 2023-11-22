defmodule ExChargebee.Gift do
  @moduledoc """
  An interface for interacting with Chargebee Gifts
  """
  use ExChargebee.Resource,
    stdops: [:list, :retrieve],
    post_root_operations: [:create_for_items],
    post_operations: [:cancel, :claim, :update_gift]
end
