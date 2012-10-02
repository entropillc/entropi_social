module EntropiSocial
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      process_registration(request.env["omniauth.auth"])
    end

    def choose_username
      @user = User.new
    end

    def create
      process_registration(session["devise.facebook_data"])

    end

    def passthru
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end

    private

      def process_registration(auth_params)
        @user = User.find_for_facebook_oauth(params[:user], auth_params, current_user)

        if @user.persisted?
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
          sign_in_and_redirect @user, :event => :authentication
        else
          session["devise.facebook_data"] = auth_params
          if request.env["omniauth.auth"]
            redirect_to choose_username_path
          else
            render 'choose_username'
          end
        end
      end

  end
end