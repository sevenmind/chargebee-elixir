defmodule ExChargebee.Usage do
  @moduledoc """
  an interface for interacting with Purchases
  """
  use ExChargebee.Resource,
    stdops: [:list],
    post_root_operations: [:pdf]
end
