defmodule ExChargebee.Invoice do
  @moduledoc """
  an interface for interacting with Invoices
  """
  use ExChargebee.Resource

  def close(id, params \\ %{}, opts \\ []) do
    post_resource(id, "/close", params, opts)
  end
end
