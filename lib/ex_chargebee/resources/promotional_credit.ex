defmodule ExChargebee.PromotionalCredit do
  @moduledoc """
  an interface for interacting with Invoices
  """
  use ExChargebee.Resource,
    stdops: [:list, :retrieve],
    post_root_operations: [:add, :deduct, :set]
end
