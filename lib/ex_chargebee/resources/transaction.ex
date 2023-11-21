defmodule ExChargebee.Transaction do
  @moduledoc """
  an interface for interacting with Card
  """
  use ExChargebee.Resource,
    stdops: [
      :retrieve,
      :list
    ],
    post_operations: [
      :delete_offline_transaction,
      :record_refund,
      :refund,
      :void
    ],
    post_root_operations: [:create_authorization]
end
