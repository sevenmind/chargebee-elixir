defmodule ExChargebee.Purchase do
  @moduledoc """
  an interface for interacting with Purchases
  """
  use ExChargebee.Resource,
    stdops: [:create],
    post_root_operations: [:estimate]
end
