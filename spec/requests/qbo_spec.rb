
describe 'QBO requests' do
  def send_invoice_with_custom_fields
    VCR.use_cassette("qbo/invoice_with_custom_fields") do
    end
  end
end
