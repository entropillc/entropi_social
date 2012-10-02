Rails.application.routes.draw do

  devise_for  :users,
              :controllers => { :sessions => 'entropi_social/user_sessions',
                                :registrations => 'entropi_social/user_registrations',
                                :omniauth_callbacks => "entropi_social/omniauth_callbacks" },
              :path_names => { :sign_out => 'logout'}

  devise_scope :user do
    get "/choose_username" => "entropi_social/omniauth_callbacks#choose_username", :as => :choose_username
    post "/create_account" => "entropi_social/omniauth_callbacks#create", :as => :create_account
    get "/signin" => "entropi_social/user_sessions#new", :as => :login
    get "/signout" => "entropi_social/user_sessions#destroy", :as => :logout
    get "/signup" => "entropi_social/user_registrations#new", :as => :signup
    get "/profile" => "devise/registrations#edit"
  end

end
