EntropiSocial::Engine.routes.draw do
  devise_for  :user,
              :controllers => { :sessions => 'user_sessions',
                                :registrations => 'user_registrations'},
              :skip => [:unlocks],
              :path_names => { :sign_out => 'logout'}
  
  devise_scope :user do
    get "/login" => "user_sessions#new", :as => :login
    get "/logout" => "user_sessions#destroy", :as => :logout
    get "/signup" => "user_registrations#new", :as => :signup
    get "/profile" => "devise/registrations#edit"
  end
end
