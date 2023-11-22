defmodule ExChargebee.ItemFamily do
  @moduledoc """
  an interface for interacting with Item Families
  """
  use ExChargebee.Resource,
    stdops: [
      :create,
      :retrieve,
      :list,
      :delete
    ]
end
