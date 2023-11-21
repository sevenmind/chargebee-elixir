defmodule ExChargebee.CreditNote do
  @moduledoc """
  an interface for interacting with Credit Notes
  """
  use ExChargebee.Resource,
    stdops: [:create, :list, :retrieve, :delete],
    post_operations: [
      :delete,
      :pdf,
      :record_refund,
      :refund,
      :remove_tax_withheld_refund,
      :resend_einvoice,
      :send_einvoice,
      :void
    ],
    get_operations: [:download_einvoice],
    post_root_operations: [:import_credit_note]
end
