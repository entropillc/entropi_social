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
            flash[:notice] = I18n.t("devise.sessions.signed_in")
            redirect_to(root_path)
          }
        end
      else
        flash[:error] = I18n.t("devise.failure.invalid")
        render :new
      end
    end

    def destroy
       signed_in = signed_in?(resource_name)
       redirect_path = after_sign_out_path_for(resource_name)
       Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
       flash[:notice] = I18n.t("devise.sessions.signed_out") if signed_in

       # We actually need to hardcode this as Rails default responder doesn't
       # support returning empty response on GET request
       respond_to do |format|
         format.any(*navigational_formats) { redirect_to redirect_path }
         format.all do
           method = "to_#{request_format}"
           text = {}.respond_to?(method) ? {}.send(method) : ""
           render :text => text, :status => :ok
         end
       end
     end
  
  end
end