require 'generators/entropi_social'
require 'rails/generators/migration'

module EntropiSocial
  module Generators
    class InstallGenerator < Base
      include ::Rails::Generators::Migration
      
      def copy_initializers
        #copy_file 'alohomora.rb', "config/initializers/entropi_social.rb"
      end
      
      def copy_configuration
        copy_file 'devise_invitable.en.yml', 'config/'
        copy_file 'devise.en.yml', 'config'
      end
      
      def copy_models
        #copy_file 'user.rb', 'app/models/user.rb'
      end
      
      def copy_migrations
        #migration_template 'create_identities.rb', 'db/migrate/create_identities.rb'
      end
      
      def add_gems
        #add_gem 'omniauth-identity'

      end
      
      def add_alohomora_routes
        #route %Q(match "/register", to: "identities#new", :as => "register")
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