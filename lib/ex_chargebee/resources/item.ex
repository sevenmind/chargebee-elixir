defmodule ExChargebee.Item do
  @moduledoc """
  an interface for interacting with Items
  """
  use ExChargebee.Resource,
    stdops: [
      :create,
      :retrieve,
      :list,
      :update,
      :delete
    ]
end
