defmodule ExChargebee.Invoice do
  @moduledoc """
  an interface for interacting with Invoices
  """
  use ExChargebee.Resource,
    post_operations: [
      :add_charge,
      :add_charge_item,
      :apply_credits,
      :apply_payments,
      :close,
      :collect_payment,
      :delete,
      :delete_line_items,
      :pdf,
      :record_payment,
      :record_refund,
      :record_tax_withheld,
      :refund,
      :remove_credit_note,
      :remove_payment,
      :remove_tax_withheld,
      :resend_einvoice,
      :send_einvoice,
      :stop_dunning,
      :sync_usages,
      :update_details,
      :void,
      :write_off
    ],
    get_operations: [:download_invoice],
    post_root_operations: [:create_for_charge_items_and_charges, :import_invoice],
    list_operations: [:payment_reference_numbers, :payments, :payment_vouchers]
end
