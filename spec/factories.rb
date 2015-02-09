

FactoryGirl.define do
  factory :account do
    name 'Tamar Trick'
    qb_token ENV['MINIMULCASTS_ACCESS_TOKEN']
    qb_secret ENV['MINIMULCASTS_ACCESS_TOKEN_SECRET']
    qb_company_id '1292740145'
  end
end
