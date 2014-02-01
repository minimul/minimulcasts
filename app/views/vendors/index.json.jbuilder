json.array!(@vendors) do |vendor|
  json.extract! vendor, :id, :name
  json.url vendor_url(vendor, format: :json)
end
