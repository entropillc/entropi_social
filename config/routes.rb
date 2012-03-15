Rails.application.routes.draw do
=begin
  devise_for  :users,
              :controllers => { :sessions => 'entropi_social/user_sessions',
                                :registrations => 'entropi_social/user_registrations',
                                :omniauth_callbacks => "users/omniauth_callbacks" },
              :skip => [:unlocks],
              :path_names => { :sign_out => 'logout'}
  
  devise_scope :user do
    get "/signin" => "entropi_social/user_sessions#new", :as => :login
    get "/signout" => "entropi_social/user_sessions#destroy", :as => :logout
    get "/signup" => "entropi_social/user_registrations#new", :as => :signup
    get "/profile" => "devise/registrations#edit"
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru', :as => :passthru
  end
=end
  
end
