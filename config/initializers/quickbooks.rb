
QB_KEY = ENV['MINIMULCASTS_CONSUMER_KEY']
QB_SECRET = ENV['MINIMULCASTS_CONSUMER_SECRET']

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
    :access_token_path    => "/oauth/v1/get_access_token"
})

Quickbooks.sandbox_mode = true

Quickbooks::Base.configure do |c|
  c.persistent_token = 'qb_token'
  c.persistent_secret = 'qb_secret'
  c.persistent_company_id = 'qb_company_id'
end
