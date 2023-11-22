defmodule ExChargebee.PaymentSource do
  @moduledoc """
  an interface for interacting with PaymentSources
  """
  use ExChargebee.Resource,
    stdops: [
      :retrieve,
      :list,
      :delete
    ],
    post_operations: [
      :export_payment_source,
      :switch_gateway_account,
      :update_bank_account,
      :update_card,
      :verify_bank_account
    ],
    post_root_operations: [
      :create_bank_account,
      :create_card,
      :create_using_payment_intent,
      :create_using_permanent_token,
      :create_using_temp_token,
      :create_using_token,
      :create_voucher_payment_source
    ]
end
