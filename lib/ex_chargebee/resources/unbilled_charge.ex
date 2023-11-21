defmodule ExChargebee.UnbilledCharge do
  @moduledoc """
  an interface for interacting with Unbilled Charges
  """
  use ExChargebee.Resource,
    stdops: [:create, :list, :delete],
    post_root_operations: [:invoice_unbilled_charges, :invoice_now_estimate]
end
