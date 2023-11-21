defmodule ExChargebee.VirtualBankAccount do
  @moduledoc """
  an interface for interacting with Card
  """
  use ExChargebee.Resource,
    stdops: [
      :create,
      :retrieve,
      :list,
      :delete
    ],
    post_operations: [:delete_local],
    post_root_operations: [:create_using_permanent_token]
end
