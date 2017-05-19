$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'monologue/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'monologue'
  s.version     = Monologue::VERSION
  s.authors     = ['Jean-Philippe Boily | @jipiboily']
  s.email       = ['j@jipi.ca']
  s.homepage    = 'http://github.com/jipiboily/monologue'
  s.summary     = 'Monologue is a basic blogging engine.' \
    ' It is a Rails mountable engine so it can be mounted in any 4.0.X + apps'
  s.description = 'Monologue is a basic blogging engine.' \
    ' It is a Rails mountable engine so it can be mounted in any 4.0.X + apps'

  s.files = Dir['{app,config,db,lib,vendor}/**/*'] +
            ['MIT-LICENSE', 'Rakefile', 'README.md', 'deprecations.rb']

  s.add_dependency 'rails', '>= 5.0'
  s.add_dependency 'bcrypt', '~> 3.1.7'
  s.add_dependency 'coffee-rails', '>= 4.0.0'
  s.add_dependency 'truncate_html'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'rails-i18n'
  s.add_dependency 'ckeditor'
  s.add_dependency 'select2-rails', '~> 3.2'
  s.add_dependency 'sass-rails', '~> 5.0.0'
  s.add_dependency 'responders'

  s.add_development_dependency 'rspec-rails', '~> 2.8'
  s.add_development_dependency 'factory_girl_rails', '~> 1.4.0'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'shoulda', '~> 2.11'
  s.add_development_dependency 'shoulda-matchers', '>= 3'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rails-controller-testing'
end
