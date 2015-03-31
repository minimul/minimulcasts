if defined? Rails
  begin
    require 'factory_girl'
    include FactoryGirl::Syntax::Methods
    Dir[Rails.root.join("spec/factories/**/*.rb")].each { |f| require f }
  rescue LoadError
  end
end
