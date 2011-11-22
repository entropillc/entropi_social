EntropiSocial::Engine.routes.draw do
  devise_for  :user,
              :controllers => { :sessions => 'entropi_social/user_sessions',
                                :registrations => 'entropi_social/user_registrations'},
              :skip => [:unlocks],
              :path_names => { :sign_out => 'logout'}
  
  devise_scope :user do
    get "/signin" => "user_sessions#new", :as => :login
    get "/signout" => "user_sessions#destroy", :as => :logout
    get "/signup" => "user_registrations#new", :as => :signup
    get "/profile" => "devise/registrations#edit"
  end
  
end
