$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "entropi_social/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "entropi_social"
  s.version     = EntropiSocial::VERSION
  s.authors     = ["Nicholas W. Watson"]
  s.email       = ["nick@entropi.co"]
  s.homepage    = "http://github/entropillc/entropi_social"
  s.summary     = "Gem containing authentication and common social features such as Friends, Groups, etc."
  s.description = "Entropi Social is a gem created to enable the quick creation of social features in a Rails 3.1.1 application including Authentication, Authoriziation, Groups, Friends, etc."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 3.1.1'
  s.add_dependency 'devise', '1.4.9'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
