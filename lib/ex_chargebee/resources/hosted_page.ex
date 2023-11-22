defmodule ExChargebee.HostedPage do
  @moduledoc """
  an interface for interacting with HostedPages
  """
  use ExChargebee.Resource,
    stdops: [
      :create,
      :retrieve,
      :list,
      :update,
      :delete
    ],
    post_operations: [
      :acknowledge
    ],
    post_root_operations: [
      :accept_quote,
      :checkout_existing_for_items,
      :checkout_gift_for_items,
      :checkout_new_for_items,
      :checkout_one_time_for_items,
      :claim_gift,
      :collect_now,
      :events,
      :extend_subscription,
      :manage_payment_sources,
      :pre_cancel,
      :retrieve_agreement_pdf,
      :update_payment_method,
      :view_voucher
    ]
end
