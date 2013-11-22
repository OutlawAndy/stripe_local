$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'stripe_local/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'stripe_local'
  s.version     = StripeLocal::VERSION
  s.authors     = ['Andy Cohen']
  s.email       = ['outlawandy@gmail.com']
  s.homepage    = 'https://github.com/Outlawandy/stripe_local'
  s.summary     = 'StripeLocal is a collection of ActiveRecord resources that mirror the Stripe Api.  It provides simple, synchronous access to Stripe Objects as a convenience and further abstraction ontop of the already great, stripe-ruby gem.'
  s.description = 'A RailsEngine offering local synchronization of your Stripe resources'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.0.0'
  s.add_dependency 'rails-observers', '~> 0.1.2'
  s.add_dependency 'stripe', '~> 1.8.8'
  s.add_dependency 'multi_json', '~> 1.0'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'coffee-rails', '~> 4.0.0'
  s.add_development_dependency 'sass-rails', '~> 4.0.0'
  s.add_development_dependency 'thin'
end
