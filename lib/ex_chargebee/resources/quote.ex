defmodule ExChargebee.Quote do
  @moduledoc """
  an interface for interacting with Quotes
  """

  use ExChargebee.Resource,
    post_operations: [
      :edit_create_subscription_quote_for_items,
      :edit_update_subscription_quote_for_items,
      :edit_for_charge_items_and_charges,
      :convert,
      :update_status,
      :extend_expiry_date,
      :delete
    ],
    post_root_operations: [
      :update_subscription_quote_for_items,
      :create_for_charge_items_and_charges
    ],
    list_operations: [:quote_line_groups]

  def pdf(quote_id, params \\ %{}, opts \\ []) do
    ExChargebee.Interface.post("/quotes/#{quote_id}/pdf", params, opts)
    |> Map.get("download")
  end
end
