defmodule ExChargebee.Event do
  @moduledoc """
  an interface for interacting with Events
  """
  use ExChargebee.Resource,
    stdops: [
      :list,
      :retrieve
    ]
end
