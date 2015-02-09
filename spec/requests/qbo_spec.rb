require 'rails_helper'

describe 'QBO requests' do
  it 'send_invoice_with_custom_fields' do
    account = create(:account)
    base = Quickbooks::Base.new(account, :invoice)
    invoice = base.qr_model(:invoice)
    custom_field = base.qr_model(:custom_field)
    custom_field.name = "LFI Invoice #"
    custom_field.type = "StringType"
    custom_field.string_value = "LFI12345678"
    invoice.custom_fields = [custom_field]
    puts invoice.to_xml
    #invoice_service = base.create_service_for(:invoice)
    #invoice_service = Quickbooks::Base.new(account, :invoice)
    #puts invoice_service
    VCR.use_cassette("qbo/invoice_with_custom_fields") do
      base.service.create(invoice)
    end
  end
end
