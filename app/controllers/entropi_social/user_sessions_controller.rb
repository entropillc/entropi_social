module EntropiSocial
  class UserSessionsController < Devise::SessionsController
  
    # GET /resource/sign_in
    def new
      super
    end

    def create
      authenticate_user!

      if user_signed_in?
        respond_to do |format|
          format.html {
            flash[:notice] = I18n.t("logged_in_succesfully")
            redirect_to(root_path)
          }
        end
      else
        flash[:error] = I18n.t("devise.failure.invalid")
        render :new
      end
    end

    def destroy
      session.clear
      super
    end
  
  end
end