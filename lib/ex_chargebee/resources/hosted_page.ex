defmodule ExChargebee.HostedPage do
  @moduledoc """
  an interface for interacting with HostedPages
  """
  use ExChargebee.Resource

  def checkout_new(params) do
    create(params, "/checkout_new")
  end

  def checkout_existing(params) do
    create(params, "/checkout_existing")
  end
end
