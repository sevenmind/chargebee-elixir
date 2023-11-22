defmodule ExChargebee.Order do
  @moduledoc """
  an interface for interacting with Orders
  """
  use ExChargebee.Resource,
    post_root_operations: [
      :import_order
    ],
    post_operations: [
      :assign_order_number,
      :cancel,
      :create_refundable_credit_note,
      :reopen,
      :delete,
      :resend
    ]
end
