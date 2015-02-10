require 'rails_helper'

describe 'QBO requests' do
  it 'send_invoice_with_custom_fields' do
    account = create(:account)
    base = Quickbooks::Base.new(account, :invoice)
    invoice = base.qr_model(:invoice)
    custom_field = base.qr_model(:custom_field)
    custom_field.id = 2
    custom_field.name = "LFI Invoice #"
    custom_field.type = "StringType"
    custom_field.string_value = "LFI12345678"
    invoice.custom_fields = [custom_field]

    invoice.customer_id = 2

    line_item = base.qr_model(:invoice_line_item)
    line_item.amount = 50
    line_item.description = "Plush Baby Doll"
    line_item.sales_item! do |detail|
      detail.unit_price = 50
      detail.quantity = 1
      detail.item_id = 1
      detail.tax_code_id = 'NON'
    end

    invoice.line_items << line_item
    VCR.use_cassette("qbo/invoice_with_custom_fields", record: :none) do
      result = base.service.create(invoice)
      expect(result.id).to eq 158
    end
  end
end
