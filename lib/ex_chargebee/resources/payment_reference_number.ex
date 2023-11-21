defmodule ExChargebee.PaymentReferenceNumber do
  @moduledoc """
  an interface for interacting with Unbilled Charges
  """
  use ExChargebee.Resource,
    stdops: [:list]
end
