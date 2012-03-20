module EntropiSocial
  class UserRegistrationsController < Devise::RegistrationsController
  
    # GET /resource/sign_up
      def new
        @user = User.new
        @user.build_profile  
      end

      # POST /resource/sign_up
      def create
        @user = User.new(params[:user])
        
        if @user.save  
          flash[:notice] = I18n.t("devise.registrations.signed_up")
          sign_in_and_redirect(:user, @user)
        else
          clean_up_passwords(@user)
          render 'new'
        end
      end

      # GET /resource/edit
      def edit
        super
      end

      # PUT /resource
      def update
        super
      end

      # DELETE /resource
      def destroy
        super
      end

      # GET /resource/cancel
      # Forces the session data which is usually expired after sign
      # in to be expired now. This is useful if the user wants to
      # cancel oauth signing in/up in the middle of the process,
      # removing all OAuth session data.
      def cancel
        super
      end

  end
end