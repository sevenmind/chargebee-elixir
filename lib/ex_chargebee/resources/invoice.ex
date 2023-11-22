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
      :record_payment,
      :record_tax_withheld,
      :remove_payment,
      :remove_tax_withheld,
      :resend_einvoice,
      :send_einvoice,
      :stop_dunning,
      :sync_usages,
      :update_details,
      :void,
      {"download", :pdf},
      {"credit_note", :record_refund},
      {"credit_note", :remove_credit_note},
      {"credit_note", :refund},
      {"credit_note", :write_off}
    ],
    get_operations: [{"downloads", :download_einvoice}],
    post_root_operations: [:create_for_charge_items_and_charges, :import_invoice],
    list_root_operations: [:payment_reference_numbers],
    list_operations: [:payments, :payment_vouchers]
end
