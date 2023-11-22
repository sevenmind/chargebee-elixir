defmodule ExChargebee.Card do
  @moduledoc """
  an interface for interacting with Card
  """
  use ExChargebee.Resource,
    stdops: [
      :retrieve
    ],
    post_operations: [:credit_card, :switch_gateway, :copy_card, :delete_card]
end
