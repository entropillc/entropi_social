require 'generators/entropi_social'
require 'rails/generators/migration'

module EntropiSocial
  module Generators
    class InstallGenerator < EntropiSocial::Generators::Base
      include ::Rails::Generators::Migration
      
      def copy_initializers

      end
      
      def copy_configuration
        copy_file 'devise_invitable.en.yml', 'config/devise_invitable.en.yml'
        copy_file 'devise.en.yml', 'config/devise.en.yml'
      end
      
      def copy_models
        copy_file 'user.rb', 'app/models/user.rb'
        copy_file 'profile.rb', 'app/models/profile.rb'
      end
      
      def copy_migrations
        migration_template '20111118193950_setup_entropi_social.rb', 'db/migrate/20111118193950_setup_entropi_social.rb'
      end
      
      def add_gems
        add_gem 'omniauth-identity'
        add_gem 'squeel', '~> 0.9.5'
        add_gem 'bootstrapped','0.0.6'
        add_gem 'carrierwave'
        add_gem 'fog'
        add_gem 'rmagick', '2.12.2'
      end
      
      def add_alohomora_routes
        route %Q(mount EntropiSocial::Engine => '/', :as => 'entropi_social')
      end
            
      private
      
        
      
        def self.next_migration_number( dirname )
          next_migration_number = current_migration_number(dirname) + 1
          if ActiveRecord::Base.timestamped_migrations
            [Time.now.utc.strftime("%Y%m%d%H%M%S%6N"), "%.20d" % next_migration_number].max
          else
            "%.3d" % next_migration_number
          end
        end
    end
  end
end