defmodule ExChargebee.HostedPage do
  @moduledoc """
  an interface for interacting with HostedPages
  """
  use ExChargebee.Resource

  def checkout_new(params, opts \\ []) do
    create(params, "/checkout_new", opts)
  end

  def checkout_existing(params, opts \\ []) do
    create(params, "/checkout_existing", opts)
  end
end
