defmodule ExChargebee.PaymentVoucher do
  @moduledoc """
  an interface for interacting with PaymentVoucher
  """
  use ExChargebee.Resource,
    stdops: [
      :create,
      :retrieve
    ]
end
