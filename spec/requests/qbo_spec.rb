require 'rails_helper'

describe 'QBO requests' do
  it 'creates an invoice' do
    account = create(:account)
    base = Quickbooks::Base.new(account, :invoice)
    invoice = base.qr_model(:invoice)

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
    #puts invoice.to_xml
    VCR.use_cassette("qbo/invoice/create", record: :none) do
      result = base.service.create(invoice)
      expect(result.id).to eq 159
    end
  end

  it 'creates a purchase' do
    account = create(:account)
    base = Quickbooks::Base.new(account, :purchase)
    purchase = Quickbooks::Model::Purchase.new
    purchase.payment_type = 'Cash'
    purchase.account_id = 36 # Sandbox bank/asset account: Savings
    line_item = Quickbooks::Model::PurchaseLineItem.new
    line_item.amount = 419.99
    line_item.description = "Rink Liner"
    line_item.account_based_expense! do |detail|
      detail.account_id = 28 # Sandbox expense account: Disposal fees
      detail.customer_id = 1
    end
    purchase.line_items = []
    purchase.line_items << line_item
    #puts purchase.to_xml
    VCR.use_cassette("qbo/purchase/create", record: :none) do
      result = base.service.create(purchase)
      expect(result.id).to_not be nil
    end
  end

  it 'uploads an attachment associated with a bill' do
    account = create(:account)
    base = Quickbooks::Base.new(account, :upload)
    meta = Quickbooks::Model::Attachable.new
    meta.file_name      = "qbo-attachment-1.pdf"
    meta.content_type   = "application/pdf"
    # Bill reference
    entity       = Quickbooks::Model::BaseReference.new
    entity.type  = 'Bill'
    entity.value = 126
    attach_ref = Quickbooks::Model::AttachableRef.new(entity)
    meta.attachable_ref = attach_ref 
    file = File.open("#{fixture_path}/qbo-attachment.pdf", "r")
    #puts meta.to_xml
    VCR.use_cassette("qbo/attachment/assoc_with_bill", record: :none) do
      result = base.service.upload(file.path, "application/pdf", meta)
      expect(result.id).to_not be nil
      expect(Nokogiri::XML(result.to_xml.to_s).at('AttachableRef > EntityRef').content).to eq '126'
    end
  end

end
